Map x = {
  "linkToProof": "www.google.com",
  "desc_by_student": "Nothing to describe",
  "submissiondate": "2020-07-31T13:03:32.842279Z",
  "checkedByTeacher": false,
  "catagory": "SampleCatagory"
};

class Student {
  String name;
  String roll;
  String collegeID;
  String dept;
  int points;
  List<StudentData> studentdata = [];
  Student({this.name, this.roll, this.collegeID = '', this.dept = '', this.points, List data}) {
    data.forEach((i) {
      this.studentdata.add(StudentData(
          link: i['linkToProof'],
          catagory: i['catagory'],
          checked: i['checkedByTeacher'],
          dateOfSubmission: i['submissiondate'],
          desc: i['desc_by_student']));
    });
  }

  factory Student.fromJsonData(Map jsonData) {
    return Student(
        name: jsonData['fname'],
        collegeID: jsonData['collegeID'],
        roll: jsonData['roll'],
        dept: jsonData['dept'],
        points: jsonData['points'],
        data: jsonData['student_data']);
  }
}

class StudentData {
  String link;
  String catagory;
  String desc;
  String dateOfSubmission;
  bool checked;

  StudentData({this.link, this.catagory, this.desc, this.dateOfSubmission, this.checked});
}
