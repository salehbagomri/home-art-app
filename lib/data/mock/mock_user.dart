class MockUser {
  static final Map<String, dynamic> user = {
    'name': 'سارة محمد',
    'email': 'sara.m@homeart.com',
    'phone': '+966 50 123 4567',
    'avatar': 'App_Assets/logo/homeart-logo-dark.png',
    'isPremium': true,
    'points': 1450,
    'level': 'ذهبي',
    'pointsToUpgrade': 550,
    'savedAddresses': [
      {
        'id': 'addr_1',
        'title': 'المنزل 🏠',
        'address': 'الرياض، حي النرجس، شارع الملك فهد، فيلا 12',
      },
      {
        'id': 'addr_2',
        'title': 'العمل 🏢',
        'address': 'الرياض، حي العليا، برج المملكة، الدور 15',
      },
      {
        'id': 'addr_3',
        'title': 'الشاليه 🏖️',
        'address': 'الدرعية، حي البجيري، شاليه رقم 4',
      }
    ],
    'savedMeasurements': [
      {
        'id': 'meas_1',
        'title': 'غرفة المعيشة',
        'width': 5.5,
        'length': 4.0,
        'height': 3.2,
      },
      {
        'id': 'meas_2',
        'title': 'غرفة النوم الرئيسية',
        'width': 4.5,
        'length': 4.5,
        'height': 3.0,
      },
      {
        'id': 'meas_3',
        'title': 'غرفة الطعام',
        'width': 4.0,
        'length': 3.5,
        'height': 3.0,
      }
    ],
    'favoriteProducts': [
      {
        'id': 'p003',
        'name': 'كرسي استرخاء فاخر',
        'price': 1890.0,
        'image': 'App_Assets/3.jpeg',
      },
      {
        'id': 'p005',
        'name': 'كونسول خشبي فاخر',
        'price': 3450.0,
        'image': 'App_Assets/4.jpeg',
      }
    ],
    'warrantyCards': [
      {
        'id': 'war_1',
        'productName': 'أريكة زاوية فاخرة - موديل أليغانس',
        'warrantyNumber': 'WAR-2026-9874',
        'validUntil': '2031-05-20',
        'isValid': true,
      },
      {
        'id': 'war_2',
        'productName': 'كرسي بذراعين ذهبي',
        'warrantyNumber': 'WAR-2026-5432',
        'validUntil': '2029-04-18',
        'isValid': true,
      }
    ]
  };
}
