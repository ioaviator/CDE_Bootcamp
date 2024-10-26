import json
from sqlalchemy import create_engine

db_uri = 'sqlite:///airflow.db'
engine = create_engine(db_uri)


def load_to_db(cmds):
  cmd_ = json.loads(cmds)
  
  with engine.connect() as conn:
    for cmd in cmd_:
      conn.execute(cmd)