from sqlalchemy import create_engine

db_uri = 'sqlite:///airflow.db'
engine = create_engine(db_uri)

def create_table():
    # SQL statement to create the pageviews table
    create_table_sql = """
    CREATE TABLE IF NOT EXISTS pageviews (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        company TEXT NOT NULL,
        views INTEGER NOT NULL
    );
    """
    with engine.connect() as connection:
      connection.execute(create_table_sql)
