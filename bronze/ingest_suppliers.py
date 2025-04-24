import os
from common.spark_utils import get_spark_session

def run_bronze_ingest_suppliers():
    spark = get_spark_session("Bronze - Ingest Suppliers")

    # Path to raw CSV
    raw_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../data/rawzone/master/suppliers.csv")
    )

    # Path to Bronze Delta output
    bronze_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../data/bronze/suppliers")
    )

    # Read raw CSV
    df_raw = spark.read.option("header", True).csv(raw_path)

    # Write to Bronze Delta
    df_raw.write.format("delta").mode("overwrite").save(bronze_path)

    print(f"[OK] Bronze ingestion complete for suppliers → {bronze_path}")

if __name__ == "__main__":
    run_bronze_ingest_suppliers()
