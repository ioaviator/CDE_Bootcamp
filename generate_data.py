from faker import Faker
from random import choice
import csv

fake = Faker('en_US')

def customer(rows):
  customer = []

  for _ in range(rows):
    cust_id = fake.uuid4()[:8]
    first_name = fake.first_name()
    last_name = fake.last_name()
    number = f'+234{fake.msisdn()[4:]}'

    data = {
      'cust_id': cust_id,
      'firstname': first_name,
      'last_name': last_name,
      'phone_number': number,
      'email': f'{first_name}.{last_name}@{fake.free_email_domain()}'
    }
    
    customer.append(data)

  return customer


def food_menu(rows):
  menu = []
  food_menu = ['Rice', 'Egusi', 'Vegetable', 'Rice/Beans', 'Yam', 'Pepper Soup']
  category = ['Pasta', 'Sapel','Brazen']
  for _ in range(rows):

    data = {
      'menu_id': fake.msisdn(),
      'item': choice(food_menu),
      'category': choice(category),
      'price': f'{fake.pricetag()[1]}{fake.pricetag()[-2:]}'
    }

    menu.append(data)
  
  return menu


def branch(rows):

  branch_data = []
  
  for _ in range(rows):
    data = {
      'branch_id': f'{fake.uuid4()[:5]}{fake.msisdn()[:3]}',
      'location': choice(['Agege','Ikeja'])
    }

    branch_data.append(data)

  return branch_data

def payment_method(rows):
  payment_type = ['Cash', 'Debit', 'Online(Nomba)', 'Online(Paystack)', 
                  'Online(Interswitch)']
  
  payment = []
  for _ in range(rows):
    data = {
      'payment_id': f'{fake.uuid4()[:6]}{fake.msisdn()[:5]}',
      'payment_type': choice(payment_type)
    }

    payment.append(data)
  
  return payment


def date_of_order(rows):

  dates = []

  for _ in range(rows):
    date = fake.date()

    data = {
      'date': f'{choice([2022,2023,2024])}-{date[5:7]}-{date[-2:]}',
    }

    dates.append(data)
  
  return dates

def order(cust_id, branch_id, menu_ids, payment_ids,date, quantity):
  
  customer_order = []

  for _ in range(300):
    data = {
      'order_id': f'{fake.uuid4()[:3]}{fake.msisdn()[:4]}',
      'branch_id': choice(branch_id),
      'customer_id': choice(cust_id),
      'menu_id': choice(menu_ids),
      'payment_id': choice(payment_ids),
      'date': choice(date),
      'quantity': choice(quantity)
    }

    customer_order.append(data)

  return customer_order

records = 100

customer_ = customer(records)
branch_ = branch(records)
payment_method_ = payment_method(records)
food_menu_ = food_menu(records)
date_of_order_ = date_of_order(records)

date = [order_date['date'] for order_date in date_of_order_]
customer_ids = [customer['cust_id'] for customer in customer_]
branch_ids = [branch['branch_id'] for branch in branch_]
menu_ids = [food_menu['menu_id'] for food_menu in food_menu_]
payment_ids = [payment_method['payment_id'] for payment_method in payment_method_]
quantity = [str(fake.http_status_code())[0] for _ in range(5)]

order = order(customer_ids, branch_ids, menu_ids, payment_ids, date, quantity)

def save_as_csv(data, filename):
  with open(filename, 'w', newline='', encoding='utf-8') as csvfile:
    writer = csv.DictWriter(csvfile, fieldnames=data[0].keys())
    writer.writeheader()
    writer.writerows(data)


save_as_csv(customer_, './fufu_republic_dbt/seeds/customers.csv')
save_as_csv(branch_,'./fufu_republic_dbt/seeds/branch.csv')
save_as_csv(payment_method_, './fufu_republic_dbt/seeds/payment_method.csv')
save_as_csv(food_menu_, './fufu_republic_dbt/seeds/food_menu.csv')
save_as_csv(date_of_order_, './fufu_republic_dbt/seeds/date_of_order.csv')
save_as_csv(order, './fufu_republic_dbt/seeds/order.csv')