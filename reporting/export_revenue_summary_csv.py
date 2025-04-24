import os
import pyarrow as pa
from common.spark_utils import get_spark_session


def export_gold_revenue_to_csv():
    spark = get_spark_session("Export - Gold Revenue CSV")

    # Set config locally — doesn't affect other scripts
    spark.conf.set("spark.sql.execution.pandasStructHandlingMode", "legacy")

    # Load Gold data
    gold_path = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../data/gold/revenue_by_product_category_month")
    )
    df_gold = spark.read.format("delta").load(gold_path)

    # Export as Pandas CSV
    arrow_batches = df_gold._collect_as_arrow()
    table = pa.Table.from_batches(arrow_batches)
    pdf = table.to_pandas()

    output_csv = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "../exports/gold_revenue_summary.csv")
    )
    os.makedirs(os.path.dirname(output_csv), exist_ok=True)
    pdf.to_csv(output_csv, index=False)

    print(f"[OK] Gold Revenue exported to CSV: {output_csv}")


if __name__ == "__main__":
    export_gold_revenue_to_csv()
