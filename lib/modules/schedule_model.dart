class Schedule {
  final int id;
  final String subject;
  final int fromSection;
  final int toSection;
  final int sectionType;
  final int weekType;
  final int period;
  final String day;
  final String location;
  final String professor;
  final int type;
  final String teamsLink;

  Schedule({
    required this.id,
    required this.subject,
    required this.fromSection,
    required this.toSection,
    required this.sectionType,
    required this.weekType,
    required this.period,
    required this.day,
    required this.location,
    required this.professor,
    required this.type,
    required this.teamsLink,
  });
  factory Schedule.maping(Map<dynamic, dynamic> map) {
    return Schedule(
      id: map['Id'],
      subject: map['Subject'],
      fromSection: map['FromSection'],
      toSection: map['ToSection'],
      sectionType: map['SectionFor'],
      weekType: map['WeekType'],
      period: map['Period'],
      day: map['Day'],
      location: map['Location'],
      professor: map['Professor'],
      type: map['Type'],
      teamsLink: map['TeamsLink'],
    );
  }
}
