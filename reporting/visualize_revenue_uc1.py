import os
import pandas as pd
import matplotlib.pyplot as plt


base_dir = os.path.abspath(os.path.dirname(__file__))
csv_path = os.path.abspath(
    os.path.join(base_dir, "..", "exports", "gold_revenue_summary.csv")
)

# Load CSV
df = pd.read_csv(csv_path)

top10 = df.sort_values(by="TotalRevenue", ascending=False)

# Plot
plt.figure(figsize=(12, 6))
plt.barh(top10["ProductName"], top10["TotalRevenue"], color="skyblue")
plt.xlabel("Revenue (€)")
plt.title("Top  Products by Revenue (Jan 2025)")
plt.gca().invert_yaxis()  # Highest revenue on top
plt.tight_layout()

# Save the chart
output_path = os.path.join(os.path.dirname(csv_path), "../outputs/top10_products.png")
os.makedirs(os.path.dirname(output_path), exist_ok=True)
plt.savefig(os.path.abspath(output_path))
print(f"Saved: {os.path.abspath(output_path)}")

# Group by category
grouped = df.groupby("CategoryName")["TotalRevenue"].sum()

# Plot
plt.figure(figsize=(8, 8))
plt.pie(grouped, labels=grouped.index, autopct="%1.1f%%", startangle=140)
plt.title("Revenue Share by Category (Jan 2025)")
plt.axis("equal")

# Save
output_path = os.path.join(os.path.dirname(csv_path), "../outputs/revenue_pie.png")
plt.savefig(os.path.abspath(output_path))


# Prepare data
units_by_cat = df.groupby("CategoryName")["UnitsSold"].sum().sort_values(ascending=False)

# Plot
plt.figure(figsize=(10, 6))
bars = plt.bar(units_by_cat.index, units_by_cat.values, color="orange")
plt.title("Units Sold by Category")
plt.ylabel("Units Sold")
plt.xticks(rotation=45)

# Add text labels on top of bars
for bar in bars:
    height = bar.get_height()
    plt.text(
        bar.get_x() + bar.get_width() / 2,
        height,
        f'{int(height)}',
        ha='center',
        va='bottom',
        fontsize=10
    )

plt.tight_layout()

# Save the chart
output_path = os.path.join(base_dir, "..", "outputs", "units_by_category_labeled.png")
plt.savefig(os.path.abspath(output_path))
print(f"[OK] Saved chart with labels: {os.path.abspath(output_path)}")
