USE DataKing2025;


---REMOVE ALL STATES THAT DO NOT BELONG IN EITHER TABLES to ensure we have the same States in both tables--

select DD.[ID State], DD.[State], 
	   RD.[Province_State]

From [dbo].[rawData] as RD
Full outer join [dbo].[Data] as DD

ON DD.[State] = RD.[Province_State]

WHERE DD.[ID State] IS NULL

--these states below do not exist in the 'Data' table, so I will exclude when I join 
--American Samoa
--Diamond Princess
--Grand Princess
--Guam
--Northern Mariana Islands
--Recovered
--Virgin Islands



---I want to store this table and use it for further analysis in Tableau so I'll create a VIEW.

CREATE VIEW COVIDDATA_VIEW AS    

WITH RAWDATA_CTE AS (
    SELECT  
        [Province_State] AS [STATE], 
        [Country_Region] AS [REGION], 
        MAX([Last_Update]) AS [LAST UPDATE], 
        AVG(TRY_CAST([Confirmed] AS NUMERIC)) AS [CONFIRMED CASES],    ---Used TRY_CAST() to avoid errors from non-numeric values
        AVG(TRY_CAST([Deaths] AS NUMERIC)) AS [DEATHS], 
        AVG(TRY_CAST([Incident_Rate] AS NUMERIC)) AS [INCIDENT RATE], 
        AVG(TRY_CAST([Case_Fatality_Ratio] AS NUMERIC)) AS [CASE FATALITY RATIO]
    FROM [dbo].[rawData]
    WHERE 
        -- using Trim function to ensure no NULLs or empty values
        [Province_State] IS NOT NULL AND TRIM([Province_State]) <> '' 
        AND [Country_Region] IS NOT NULL AND TRIM([Country_Region]) <> ''
        AND [Last_Update] IS NOT NULL AND TRIM([Last_Update]) <> ''
        AND [Confirmed] IS NOT NULL AND TRIM([Confirmed]) <> ''
        AND [Deaths] IS NOT NULL AND TRIM([Deaths]) <> ''
        AND [Incident_Rate] IS NOT NULL AND TRIM([Incident_Rate]) <> ''
        AND [Case_Fatality_Ratio] IS NOT NULL AND TRIM([Case_Fatality_Ratio]) <> ''

        -- Exclude specified states identified on line 16-23)
        AND [Province_State] NOT IN (
            'American Samoa',
            'Diamond Princess',
            'Grand Princess',
            'Guam',
            'Northern Mariana Islands',
            'Recovered',
            'Virgin Islands'
        )
    GROUP BY [Province_State], [Country_Region]
)

SELECT 
    [STATE], [REGION],[LAST UPDATE], [CONFIRMED CASES], 
    [DEATHS], [INCIDENT RATE], [CASE FATALITY RATIO]
FROM RAWDATA_CTE;

//* VIEW HAS NOW BEEN CREATED *//


-- Now we join the VIEW with the [dbo].[Data] table
SELECT RR.[STATE], RR.[LAST UPDATE], RR.[CONFIRMED CASES], RR.[DEATHS], RR.[INCIDENT RATE], RR.[CASE FATALITY RATIO],
       DD.[Population] AS [POPULATION (US. CENSUS 2022)]
FROM  COVIDDATA_VIEW AS RR
INNER JOIN [dbo].[Data] AS DD
    ON RR.[STATE] = DD.[STATE]
ORDER BY RR.[STATE], RR.[REGION];

 

 //* ALTERNATIVE VIEW CREATED FOR POPULATION DATA FOR EASY EXTRACTION IN TABLEAU*//

CREATE VIEW PopDATA_VIEW AS    

WITH PopDATA_CTE AS 
    (
    SELECT  [State] AS [STATE],
	        [Population] AS [POPULATION (US. CENSUS 2022)]
	from [dbo].[Data]
	)
	SELECT * FROM PopDATA_CTE



select * from [dbo].[EducationStats]

















