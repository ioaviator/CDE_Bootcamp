import json

def load_to_db(cmds):
  cmd_ = json.loads(cmds)
  
  with engine.connect() as conn:
    for cmd in cmd_:
      conn.execute(cmd)