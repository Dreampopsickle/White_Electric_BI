import pandas as pd

payments_data = pd.read_csv("data/payments_data.csv")
orders_data = pd.read_csv("data/orders_data.csv")

enriched_data = pd.merge(payments_data, orders_data, on="order_id", how="left")

enriched_data.to_csv("data/enriched_data.csv", index=False)

print("Enriched data saved to 'data/enriched_data.csv")
