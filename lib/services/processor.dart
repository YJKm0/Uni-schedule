



import 'package:uni_schudle_try1/modules/schedule_model.dart';

class Processor 
{
List<Schedule> schedules  ;
Processor (this.schedules );
Map <int,String> dayOfTheWeek = {
    DateTime.saturday: 'Saturday',
    DateTime.sunday: 'Sunday',
    DateTime.monday: 'Monday',
    DateTime.tuesday: 'Tuesday',
    DateTime.wednesday: 'Wednesday',
    DateTime.thursday: 'Thursday',
    DateTime.friday: 'Friday',

  };
int calculateSectionType(int sectionNumber){

  int sectionType ;
  if (sectionNumber % 2 ==0)
  {
   sectionType = 2;
  }else{
    sectionType = 1;
  }
  return sectionType ;
}
int calculateWeekNumber(DateTime selectedDate){
  DateTime startingDate = DateTime(2026,9,19);
  int days = selectedDate.difference(startingDate).inDays;
  int weekNumber = (days ~/ 7) +1 ;
  return weekNumber;
}
int calculateWeekType (int weekNumber){
  int weekType;
 if (weekNumber % 2 ==0)
  {
   weekType = 2;
  }else{
    weekType = 1;
  }
  return weekType ;
}
List<Schedule> getScheduleForSection(int sectionNumber, DateTime selectedDate)
{
  

  var sectionType =calculateSectionType(sectionNumber);
  var weekType =calculateWeekType(calculateWeekNumber(selectedDate));
  var result = schedules.where(
    (s) => sectionNumber >= s.fromSection 
           && sectionNumber <= s.toSection
           && s.sectionType == sectionType
           && weekType == s.weekType
           && dayOfTheWeek[selectedDate.weekday] == s.day
    ).toList()..sort((a, b) => a.period.compareTo(b.period));
    return result ;
}






}