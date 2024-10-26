
def process_file(filepath):
  cmds = []
  companies = ["Amazon", "Apple", "Facebook", "Google", "Microsoft"]
  with open(filepath, 'rb') as f:
    for line in f:
      for company in companies:
        if(company in line.decode('utf-8') ):
          views = line.decode().strip().split(" ")[-2]
          cmds.append(f"INSERT INTO pageviews (company, views) VALUES ('{company}', {views});")
  
  return cmds
