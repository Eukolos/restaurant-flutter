
import 'package:restaurant_management_system/src/model/customer.dart';

class Customers {
  List<Customer> customers = [
    Customer(
      name: 'John',
      surname: 'Doe',
      email: 'jdoe@gmail.com',
      phone: '1234567890',
      address: '123 Main St, New York, NY 10030',
    ),
    Customer(
      name: 'Jane',
      surname: 'Doe',
      email: 'janed@gmail.com',
      phone: '0987654321',
      address: '456 Main St, New York, NY 10030',
    ),
    Customer(
      name: 'John',
      surname: 'Smith',
      email: 'jsmith@gmail.com',
      phone: '1234567890',
      address: '789 Main St, New York, NY 10030',
    ),
    Customer(
      name: 'Jane',
      surname: 'Smith',
      email: 'janes@gmail.com',
      phone: '0987654321',
      address: '012 Main St, New York, NY 10030',
    ),
  ];

  List<Customer> get() {
    return customers;
  }
}