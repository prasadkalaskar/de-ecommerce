import os
from common.spark_utils import get_spark_session

def run_silver_products():
    spark = get_spark_session("Silver - Products")

    # Load from Bronze
    base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/bronze"))
    df_products = spark.read.format("delta").load(f"{base_path}/products")
    df_subcategories = spark.read.format("delta").load(f"{base_path}/subcategories")
    df_categories = spark.read.format("delta").load(f"{base_path}/categories")
    df_sellers = spark.read.format("delta").load(f"{base_path}/sellingEntities")

    # Join SubCategory and Category
    df_joined = (
        df_products
        .join(df_subcategories, on="SubCategoryID", how="left")
        .join(df_categories, on="CategoryID", how="left")
        .join(df_sellers, on="SellingEntityID", how="left")
        .select(
            "ProductID", "ProductName", "Price",
            "SubCategoryID", "SubCategoryName",
            "CategoryID", "CategoryName",
            "SellingEntityID", "SellingEntityName"
        )
    )

    # Write to Silver
    silver_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../data/silver/products"))
    df_joined.write.format("delta").mode("overwrite").save(silver_path)

    print(f"[SUCCESS] Silver Products written to: {silver_path}")

if __name__ == "__main__":
    run_silver_products()
