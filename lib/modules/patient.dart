class Patient {
  String id;
  final String creationDate;
  final String firstName;
  final String lastName;
  final String fathersName;
  final String city;
  final String address;
  final String postalCode;
  final String houseNumber;
  final String countryBirth;
  final String profession;
  final String dateOfBirth;

  final String homePhone;
  final String email1;
  final String email2;
  final String insuranceCompany;
  final String phone;
  final String fax;
  final String hmo;
  final String treatingDoctor;

  final String status;
  final String remarks;

  Patient({
    this.id = '',
    this.creationDate = 'undefined',
    required this.firstName,
    required this.lastName,
    this.fathersName = 'undefined',
    this.city = 'undefined',
    this.address = 'undefined',
    this.postalCode = 'undefined',
    this.houseNumber = 'undefined',
    this.countryBirth = 'undefined',
    this.profession = 'undefined',
    this.dateOfBirth = 'undefined',
    this.homePhone = 'undefined',
    this.email1 = 'undefined',
    this.email2 = 'undefined',
    this.insuranceCompany = 'undefined',
    this.phone = 'undefined',
    this.fax = 'undefined',
    this.hmo = 'undefined',
    this.treatingDoctor = 'undefined',
    this.status = 'undefined',
    this.remarks = 'undefined',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'creationDate': creationDate,
        'first_name': firstName,
        'last_name': lastName,
        'fathers_name': fathersName,
        'city': city,
        'address': address,
        'postalCode': postalCode,
        'houseNumber': houseNumber,
        'countryBirth': countryBirth,
        'profession': profession,
        'date_of_birth': dateOfBirth,
        'home_phone': homePhone,
        'email1': email1,
        'email2': email2,
        'inisurance_company': insuranceCompany,
        'phone': phone,
        'fax': fax,
        'HMO': hmo,
        'treating_docrot': treatingDoctor,
        'status': status,
        'remarks': remarks
      };
  static Patient fromJson(Map<String, dynamic> json) => Patient(
      id: json['id'],
      creationDate: json['creationDate'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      fathersName: json['fathers_name'],
      city: json['city'],
      address: json['address'],
      postalCode: json['postalCode'],
      houseNumber: json['houseNumber'],
      countryBirth: json['countryBirth'],
      profession: json['profession'],
      dateOfBirth: json['date_of_birth'],
      homePhone: json['home_phone'],
      email1: json['email1'],
      email2: json['email2'],
      insuranceCompany: json['inisurance_company'],
      phone: json['phone'],
      fax: json['fax'],
      hmo: json['HMO'],
      treatingDoctor: json['treating_docrot'],
      status: json['status'],
      remarks: json['remarks']);
}
