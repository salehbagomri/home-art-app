class MockTickets {
  static final List<Map<String, dynamic>> tickets = [
    {
      'id': 'TCK-5541',
      'title': 'طلب صيانة دورية للأريكة',
      'date': '2026-05-18',
      'status': 'processing',
      'statusText': 'قيد المعالجة',
      'category': 'صيانة',
      'lastUpdate': 'تم تحديد موعد الزيارة للفني يوم الأحد القادم'
    },
    {
      'id': 'TCK-2290',
      'title': 'استفسار عن جودة قماش الكتان',
      'date': '2026-05-10',
      'status': 'closed',
      'statusText': 'مغلق',
      'category': 'استفسار',
      'lastUpdate': 'تمت الإجابة على استفسار العميل وإغلاق التذكرة'
    },
    {
      'id': 'TCK-8812',
      'title': 'تعديل مقاسات طلب التصميم الخاص',
      'date': '2026-05-22',
      'status': 'open',
      'statusText': 'مفتوح',
      'category': 'تعديل طلب',
      'lastUpdate': 'تم استلام طلب التعديل وجاري دراسته من قبل المصمم'
    }
  ];
}
