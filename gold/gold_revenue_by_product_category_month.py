import os
from pyspark.sql import functions as F
from common.spark_utils import get_spark_session

def run_gold_revenue_by_product_category_month():
    spark = get_spark_session("Gold - Revenue by Product/Category/Month")

    # Load Silver table
    silver_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../data/silver/orderitems")
    )
    df_orderitems = spark.read.format("delta").load(silver_path)

    # Perform aggregation using DataFrame API
    df_gold = (
        df_orderitems
        .groupBy("ProductID", "ProductName", "CategoryID", "CategoryName", "OrderMonth")
        .agg(
            F.sum(F.col("ItemPrice") * F.col("Quantity")).alias("TotalRevenue"),
            F.sum("Quantity").alias("UnitsSold")
        )
        .orderBy("OrderMonth", F.col("TotalRevenue").desc())
    )

    # Write to Delta in Gold layer
    gold_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../data/gold/revenue_by_product_category_month")
    )
    df_gold.write.format("delta").mode("overwrite").save(gold_path)

    print(f"[OK] Gold table saved to: {gold_path}")

if __name__ == "__main__":
    run_gold_revenue_by_product_category_month()
