class MockOrders {
  static final List<Map<String, dynamic>> orders = [
    {
      'id': 'ORD-9874',
      'date': '2026-05-20',
      'status': 'inProgress',
      'statusText': 'جاري التوصيل',
      'total': 6850.0,
      'paymentMethod': 'مدى',
      'deliveryAddress': 'الرياض، حي النرجس، شارع الملك فهد',
      'expectedDeliveryDate': '2026-05-27',
      'items': [
        {
          'id': 'p001',
          'name': 'أريكة زاوية فاخرة - موديل أليغانس',
          'price': 6850.0,
          'material': 'قماش مخمل فاخر',
          'color': '#E8DCC8',
          'size': '4 مقاعد',
          'quantity': 1,
          'image': 'App_Assets/1.jpeg',
        }
      ],
      'timeline': [
        {
          'title': 'تم استلام طلب التصميم',
          'subtitle': '2026-05-20 10:30 ص',
          'isCompleted': true,
        },
        {
          'title': 'تم تجهيز عرض السعر',
          'subtitle': '2026-05-20 02:15 م',
          'isCompleted': true,
        },
        {
          'title': 'طلبك قيد التصنيع',
          'subtitle': '2026-05-21 08:00 ص',
          'isCompleted': true,
        },
        {
          'title': 'جاري التوصيل',
          'subtitle': '2026-05-23 09:00 ص',
          'isCompleted': true,
          'isCurrent': true,
        },
        {
          'title': 'تم التركيب والضمان',
          'subtitle': 'متوقع في 2026-05-27',
          'isCompleted': false,
        }
      ]
    },
    {
      'id': 'ORD-5432',
      'date': '2026-04-12',
      'status': 'completed',
      'statusText': 'تم التركيب',
      'total': 2350.0,
      'paymentMethod': 'Apple Pay',
      'deliveryAddress': 'الرياض، حي الصحافة، شارع العليا',
      'expectedDeliveryDate': '2026-04-18',
      'items': [
        {
          'id': 'p002',
          'name': 'كرسي بذراعين ذهبي',
          'price': 2350.0,
          'material': 'مخمل - بيج / ذهبي',
          'color': '#BDA36D',
          'size': 'مقاس قياسي',
          'quantity': 1,
          'image': 'App_Assets/2.jpeg',
        }
      ],
      'timeline': [
        {
          'title': 'تم استلام طلب التصميم',
          'subtitle': '2026-04-12 09:00 ص',
          'isCompleted': true,
        },
        {
          'title': 'تم تجهيز عرض السعر',
          'subtitle': '2026-04-12 11:30 ص',
          'isCompleted': true,
        },
        {
          'title': 'طلبك قيد التصنيع',
          'subtitle': '2026-04-13 10:00 ص',
          'isCompleted': true,
        },
        {
          'title': 'جاري التوصيل',
          'subtitle': '2026-04-17 01:00 م',
          'isCompleted': true,
        },
        {
          'title': 'تم التركيب والضمان',
          'subtitle': '2026-04-18 04:00 م',
          'isCompleted': true,
          'isCurrent': true,
        }
      ]
    },
    {
      'id': 'ORD-1122',
      'date': '2026-03-01',
      'status': 'cancelled',
      'statusText': 'ملغي',
      'total': 1890.0,
      'paymentMethod': 'بطاقة ائتمانية',
      'deliveryAddress': 'الرياض، حي الملقا، طريق أنس بن مالك',
      'expectedDeliveryDate': '2026-03-08',
      'items': [
        {
          'id': 'p003',
          'name': 'كرسي استرخاء فاخر',
          'price': 1890.0,
          'material': 'قماش كتان - بيج',
          'color': '#6B543E',
          'size': 'مقاس قياسي',
          'quantity': 1,
          'image': 'App_Assets/3.jpeg',
        }
      ],
      'timeline': [
        {
          'title': 'تم استلام طلب التصميم',
          'subtitle': '2026-03-01 12:00 م',
          'isCompleted': true,
        },
        {
          'title': 'تم إلغاء الطلب بناءً على رغبة العميل',
          'subtitle': '2026-03-02 09:30 ص',
          'isCompleted': true,
          'isCurrent': true,
        }
      ]
    }
  ];
}
