class Job {
  final int id;
  final String title;
  final String company;
  final String location;
  final String description;
  final int salary; // simple integer value

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.description,
    required this.salary,
  });

  factory Job.fromProductJson(Map<String, dynamic> j) {
    final id = j['id'] as int;
    final title = (j['title'] ?? 'Untitled').toString();
    final company = (j['brand'] ?? 'Acme Corp').toString();
    // Use category as a pseudo-location label for demo
    final location = ((j['category'] ?? 'remote').toString()).replaceAll('-', ' ').toUpperCase();
    final description = (j['description'] ?? '').toString();
    // Map price (number) to a fake annual salary figure
    final price = (j['price'] is num) ? (j['price'] as num).toInt() : 50;
    final salary = price * 1000;
    return Job(
      id: id,
      title: title,
      company: company,
      location: location,
      description: description,
      salary: salary,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'company': company,
    'location': location,
    'description': description,
    'salary': salary,
  };

  factory Job.fromMap(Map<dynamic, dynamic> m) => Job(
    id: m['id'] as int,
    title: m['title'] as String,
    company: m['company'] as String,
    location: m['location'] as String,
    description: m['description'] as String,
    salary: m['salary'] as int,
  );
}
