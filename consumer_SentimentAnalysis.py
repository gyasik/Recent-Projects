import os # This checks for file existence

# Here's a list of required libraries
libraries = ["pandas", "numpy", "matplotlib", "seaborn", "nltk", "openpyxl"]

# Now I will Install each library using pip
for lib in libraries:
    os.system(f"pip install {lib}")

import pandas as pd  # For data handling
import numpy as np  # For numerical operations
import matplotlib.pyplot as plt  # For visualization (I'm importing this in case I need to plot anything)
import seaborn as sns  # For statistical visualizations (might need)
import nltk  # Natural Language Toolkit
from nltk.sentiment import SentimentIntensityAnalyzer  # VADER sentiment analysis


# Set visualization style (may not use in this instance)
plt.style.use('ggplot')

# Download the VADER lexicon for sentiment analysis using teh nltk library I imported
nltk.download('vader_lexicon')

# File paths (Input = my flat csv and Output = location to save the sentiment output)
input_file_path = r"my file path"
output_file_path = r"my file path"

# Now I need to define a function to load dataset
def load_data(file_path):
    if not os.path.exists(file_path):
        print("Error: File not found! Check the file path.")
        return None
    
    df = pd.read_csv(file_path)  # this reads the CSV file
    print("Original Data Shape:", df.shape)
    df = df.head(500)  # I only want the first 500 rows
    print("Reduced Data Shape:", df.shape)
    return df

# Sentiment analysis function using VADER
def polarity_scores_vader(text):
    sia = SentimentIntensityAnalyzer()  # this initializes VADER
    return sia.polarity_scores(str(text))  # This converts text to string and analyze sentiment

# Now I apply sentiment analysis my dataset (and to a specific column ("reviewText"))
def analyze_reviews(df):
    df['sentiment_scores'] = df['reviewText'].astype(str).apply(polarity_scores_vader)

    # I now need to extract sentiment components into separate columns
    df['negative'] = df['sentiment_scores'].apply(lambda x: x['neg'])
    df['neutral'] = df['sentiment_scores'].apply(lambda x: x['neu'])
    df['positive'] = df['sentiment_scores'].apply(lambda x: x['pos'])
    df['compound'] = df['sentiment_scores'].apply(lambda x: x['compound'])

    return df

# Now let's save results to CSV file in the output file I indicated in lines 24-26
def save_results(df, output_path):
    df.to_csv(output_path + ".csv", index=False)  # Save as CSV
    df.to_excel(output_path + ".xlsx", index=False)  # Save as Excel
    print(f"Results saved as {output_path}.csv and {output_path}.xlsx")

# Here's the main execution
if __name__ == "__main__":
    df = load_data(input_file_path)  # Load data
    if df is not None:  # Proceed only if file exists
        df = analyze_reviews(df)  # Analyze sentiment
        print(df[['reviewText', 'negative', 'neutral', 'positive', 'compound']].head())  # Quick QA check This displays sample results to check output 
        save_results(df, output_file_path)  # And finally, I will save to CSV
