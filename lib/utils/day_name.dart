const _fullDays = [
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu',
];

const _shortDays = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

const _shortMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Mengembalikan nama hari bahasa Indonesia, atau 'Hari Ini' jika isToday true.
String dayName(DateTime date, {bool isToday = false}) {
  if (isToday) return 'Hari Ini';
  return _fullDays[date.weekday - 1];
}

/// Mengembalikan nama hari singkat 3 huruf (Sen..Min).
String dayShort(DateTime date) {
  return _shortDays[date.weekday - 1];
}

/// Memformat tanggal singkat, contoh: '26 Nov'.
String shortDate(DateTime date) {
  return '${date.day} ${_shortMonths[date.month - 1]}';
}

/// Memformat hari dan tanggal lengkap, contoh: 'Rabu, 25 Nov'.
String fullDayDate(DateTime date) {
  return '${_fullDays[date.weekday - 1]}, ${shortDate(date)}';
}
