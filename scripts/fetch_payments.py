from dependencies import pd, req, os, time, datetime, load_dotenv

# print('packages are in')

load_dotenv()
# print("env is loaded")

# # Access Square API Token
ACCESS_TOKEN = os.getenv("SQUARE_ACCESS_TOKEN")
if not ACCESS_TOKEN:
    raise ValueError("Square API TOKEN not found in .env file!")

PAYMENTS_API_URL = 'https://connect.squareup.com/v2/payments'
headers = {
    "Square_Version": "2024-11-20",
    "Authorization": f"Bearer {ACCESS_TOKEN}",
    "Content-Type": "application/json"
}

def fetch_payment_data(start_date, end_date):
    response = req.get(
        PAYMENTS_API_URL,
        headers=headers,
        params={
            "begin_time": f"{start_date}T00:00:00Z",
            "end_time": f"{end_date}T23:59:59Z",
            "sort_order": "ASC"
        }
    )
    if response.status_code == 200:
        return pd.json_normalize(response.json().get("payments", []))
    else:
        print(f"Error: {response.status_code} - {response.text}")
        return pd.DataFrame()
    
# start_date = "2024-01-01"
# end_date = "2024-01-30"
# payments_data = fetch_payment_data(start_date, end_date)

# output_folder = "../data"
# output_file = f"{output_folder}/payment_data.csv"

# payments_data.to_csv(output_file, index=False)
# print(f"File saved to {output_file}")