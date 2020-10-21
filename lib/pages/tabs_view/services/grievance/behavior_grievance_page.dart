import 'package:aue/model/grievance_behavior_form.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_dropdown.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:aue/widgets/loadingWidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BehaviorGrievancePage extends StatefulWidget {
  final String title;
  final String content;

  BehaviorGrievancePage({@required this.title, @required this.content});

  @override
  _BehaviorGrievancePageState createState() => _BehaviorGrievancePageState();
}

class _BehaviorGrievancePageState extends State<BehaviorGrievancePage> {
  Future<GrievanceBehaviorForm> _grievanceBehaviorFormFuture;

  GrievanceBehaviorCategory _selectedGrievanceBehaviorCategory;

  final TextEditingController _grievanceDetailsText = TextEditingController();

  Widget _buildCard(String title, String description) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        margin: const EdgeInsets.all(0.0),
        shadowColor: Colors.black38,
        child: Padding(
          padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.blackGrey,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: DS.height * 0.015),
              Text(
                description,
                style: const TextStyle(color: AppColors.blueGrey, fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.4),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrievanceDetailsTextField() {
    const InputBorder _inputBorder = const OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Grievance Details',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        SizedBox(height: DS.height * 0.02),
        TextField(
          controller: _grievanceDetailsText,
          decoration: InputDecoration(
            border: _inputBorder,
            focusedErrorBorder: _inputBorder,
            disabledBorder: _inputBorder,
            errorBorder: _inputBorder,
            contentPadding: const EdgeInsets.all(7.0),
            enabledBorder: _inputBorder,
            focusedBorder: _inputBorder,
            hintText: 'Please provide a description of your grievance in detail (*)',
            hintStyle: const TextStyle(
              color: AppColors.blueGrey,
              fontWeight: FontWeight.w700,
              fontSize: 14.0,
            ),
          ),
          style: const TextStyle(
            color: AppColors.blueGrey,
            fontWeight: FontWeight.w700,
            fontSize: 14.0,
          ),
          maxLines: 4,
        ),
      ],
    );
  }

  void getGrievanceBehaviorForm() {
    _grievanceBehaviorFormFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _grievanceBehaviorFormFuture = Repository().getGrievanceBehaviorForm(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getGrievanceBehaviorForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 44.0,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0).subtract(const EdgeInsets.only(bottom: 16.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButton(color: AppColors.primary),
                  Text(
                    "New Grievance",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: DS.setSP(20),
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: ImageIcon(
                      const AssetImage(Images.bell),
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: DS.width * 0.05, vertical: DS.height * 0.01),
              child: _buildCard(this.widget.title, this.widget.content),
            ),
            FutureBuilder<GrievanceBehaviorForm>(
                future: _grievanceBehaviorFormFuture,
                builder: (BuildContext context, AsyncSnapshot<GrievanceBehaviorForm> snapshot) {
                  if (snapshot.isLoading) {
                    return LoadingWidget();
                  }
                  if (snapshot.hasError && snapshot.error != null) {
                    return CustomErrorWidget(
                      err: snapshot.error,
                      onRetryTap: () => this.getGrievanceBehaviorForm(),
                    );
                  }
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: DS.width * 0.07, vertical: 14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomDropdown<GrievanceBehaviorCategory>(
                          label: 'Grievance Category',
                          dataList: snapshot.data.category,
                          textKey: 'Name',
                          onDataSelect: (GrievanceBehaviorCategory selectedGrievanceCategory) {
                            print(selectedGrievanceCategory);
                            _selectedGrievanceBehaviorCategory = selectedGrievanceCategory;
                            setState(() {});
                          },
                        ),
                        Transform.translate(
                          offset: const Offset(0, -12),
                          child: Text(
                            this._selectedGrievanceBehaviorCategory?.description ?? '',
                            style: const TextStyle(color: AppColors.blueGrey, fontWeight: FontWeight.w300, fontSize: 12),
                          ),
                        ),
                        if (_selectedGrievanceBehaviorCategory != null) SizedBox(height: DS.height * 0.01),
                        if (_selectedGrievanceBehaviorCategory?.name?.toLowerCase()?.contains('staff') ?? false)
                          CustomDropdown<GrievanceBehaviorStaff>(
                            label: 'Staff Name',
                            dataList: snapshot.data.staffs,
                            textKey: 'Name',
                            onDataSelect: (GrievanceBehaviorStaff selectedGrievanceStaff) {
                              print(selectedGrievanceStaff);
                            },
                          ),
                        if (_selectedGrievanceBehaviorCategory?.name?.toLowerCase()?.contains('student') ?? false)
                          AddNamesToList(
                            onNameAdded: (List<String> names) {
                              print(names);
                            },
                            label: 'Student Name',
                          ),
                        if (_selectedGrievanceBehaviorCategory?.name?.toLowerCase()?.contains('faculty') ?? false)
                          CustomDropdown<GrievanceBehaviorFaculty>(
                            label: 'Faculty Name',
                            dataList: snapshot.data.faculties,
                            textKey: 'Name',
                            onDataSelect: (GrievanceBehaviorFaculty selectedGrievanceFaculty) {
                              print(selectedGrievanceFaculty);
                            },
                          ),
                        if (_selectedGrievanceBehaviorCategory != null) SizedBox(height: DS.height * 0.02),
                        SelectIncidentDate(),
                        SizedBox(height: DS.height * 0.02),
                        SelectIncidentTime(),
                        SizedBox(height: DS.height * 0.02),
                        CustomDropdown<GrievanceBehaviorIncidentLocation>(
                          label: 'Incident Location (*)',
                          dataList: snapshot.data.incidentLocation,
                          textKey: 'Name',
                          onDataSelect: (GrievanceBehaviorIncidentLocation selectedGrievanceBehaviorIncidentLocation) {
                            print(selectedGrievanceBehaviorIncidentLocation);
                          },
                        ),
                        AddNamesToList(
                          onNameAdded: (List<String> names) {
                            print(names);
                          },
                          label: 'Witnesses',
                        ),
                        SizedBox(height: DS.height * 0.02),
                        _buildGrievanceDetailsTextField(),
                        SizedBox(height: DS.height * 0.02),
                        SizedBox(
                          width: double.infinity,
                          child: Card(
                            elevation: 4.0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(12.0),
                              ),
                            ),
                            margin: const EdgeInsets.all(0.0),
                            shadowColor: Colors.black38,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0).add(const EdgeInsets.symmetric(horizontal: 6.0)),
                              child: Text(
                                'I hereby declare that all information provided in this grievance form is true and accurate to the best of my knowledge.',
                                style: const TextStyle(color: AppColors.blueGrey, fontSize: 14.0, fontWeight: FontWeight.w600, height: 1.4),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                        Card(
                          color: Colors.white,
                          elevation: 4.0,
                          shape: const RoundedRectangleBorder(borderRadius: const BorderRadius.all(const Radius.circular(12.0))),
                          margin: const EdgeInsets.all(10.0).add(const EdgeInsets.symmetric(vertical: 10.0)),
                          shadowColor: Colors.black38,
                          child: InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Agree & Save Grievance',
                                    style: const TextStyle(color: AppColors.primary, fontSize: 16.0, fontWeight: FontWeight.w700),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.fromBorderSide(
                                        const BorderSide(color: AppColors.primary, width: 1.5),
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.arrow_forward,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class AddNamesToList extends StatefulWidget {
  final void Function(List<String> names) onNameAdded;
  final String label;

  AddNamesToList({@required this.onNameAdded, @required this.label});

  @override
  _AddNamesToListState createState() => _AddNamesToListState();
}

class _AddNamesToListState extends State<AddNamesToList> {
  TextEditingController _nameText = TextEditingController();
  List<String> _names = [
  ];

  @override
  Widget build(BuildContext context) {
    const InputBorder _inputBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: _nameText,
              decoration: InputDecoration(
                border: _inputBorder,
                focusedErrorBorder: _inputBorder,
                disabledBorder: _inputBorder,
                errorBorder: _inputBorder,
                contentPadding: const EdgeInsets.all(.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
                hintText: 'Add name here',
                hintStyle: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    print(_nameText.text);
                    if (_nameText.text == '' || _nameText.text == null || _nameText.text.trim() == '') {
                      return;
                    }
                    _names.add(_nameText.text);
                    _nameText.text = '';
                    // if (_nameText.text != null || _nameText.text.trim() != '') {
                    //   _names.add(_nameText.text);
                    // } else {
                    //   _nameText.text = '';
                    // }
                  });
                },
                child: const Icon(
                  Icons.add_circle_outline,
                  color: AppColors.blueGrey,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: DS.height * 0.01),
        ...List.generate(
          _names.length,
          (int index) {
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 15.0,
                      height: 15.0,
                      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 4.5,
                          ),
                          shape: BoxShape.circle),
                    ),
                    Text(
                      _names[index],
                      style: const TextStyle(
                        color: AppColors.blackGrey,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                if (index != _names.length - 1)
                  const Divider(
                    thickness: 0.6,
                    color: AppColors.blueGrey,
                  ),
              ],
            );
          },
        )
      ],
    );
  }
}

class SelectIncidentDate extends StatefulWidget {
  @override
  _SelectIncidentDateState createState() => _SelectIncidentDateState();
}

class _SelectIncidentDateState extends State<SelectIncidentDate> {
  TextEditingController _dateText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const InputBorder _inputBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Incident Date (*)',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: _dateText,
              decoration: InputDecoration(
                border: _inputBorder,
                focusedErrorBorder: _inputBorder,
                disabledBorder: _inputBorder,
                errorBorder: _inputBorder,
                contentPadding: const EdgeInsets.all(.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
                hintText: 'Select Date',
                hintStyle: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
              onTap: () async {
                DateTime _selectedDateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        // primaryColor: AppColors.green,
                        // accentColor: const Color(0xFF8CE7F1),
                        colorScheme: ColorScheme.light(primary: AppColors.primary),
                        // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child,
                    );
                  },
                );
                _dateText.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
              },
              readOnly: true,
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Positioned(
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: GestureDetector(
                onTap: () async {
                  DateTime _selectedDateTime = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                    lastDate: DateTime.now(),
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          // primaryColor: AppColors.green,
                          // accentColor: const Color(0xFF8CE7F1),
                          colorScheme: ColorScheme.light(primary: AppColors.primary),
                          // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                        ),
                        child: child,
                      );
                    },
                  );
                  _dateText.text = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
                },
                child: const Icon(
                  Icons.calendar_today,
                  color: AppColors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class SelectIncidentTime extends StatefulWidget {
  @override
  _SelectIncidentTimeState createState() => _SelectIncidentTimeState();
}

class _SelectIncidentTimeState extends State<SelectIncidentTime> {
  TextEditingController _timeText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const InputBorder _inputBorder = const UnderlineInputBorder(
      borderSide: const BorderSide(color: AppColors.blueGrey),
      borderRadius: const BorderRadius.all(
        const Radius.circular(0.0),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Incident Time',
          style: const TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
        Stack(
          children: [
            TextField(
              controller: _timeText,
              decoration: InputDecoration(
                border: _inputBorder,
                focusedErrorBorder: _inputBorder,
                disabledBorder: _inputBorder,
                errorBorder: _inputBorder,
                contentPadding: const EdgeInsets.all(.0),
                enabledBorder: _inputBorder,
                focusedBorder: _inputBorder,
                hintText: '( e.g. 10:10 AM )',
                hintStyle: const TextStyle(
                  color: AppColors.blueGrey,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.0,
                ),
              ),
              onTap: () async {
                TimeOfDay _selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        // primaryColor: AppColors.green,
                        // accentColor: const Color(0xFF8CE7F1),
                        colorScheme: ColorScheme.light(primary: AppColors.primary),
                        // buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
                      ),
                      child: child,
                    );
                  },
                );
                _timeText.text = _selectedTime.format(context);
              },
              readOnly: true,
              style: const TextStyle(
                color: AppColors.blueGrey,
                fontWeight: FontWeight.w700,
                fontSize: 14.0,
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                right: 0.0,
                top: 0.0,
                bottom: 0.0,
                child: GestureDetector(
                  onTap: () async {
                    TimeOfDay _selectedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    _timeText.text = _selectedTime.format(context);
                  },
                  child: const Icon(
                    Icons.access_time,
                    color: AppColors.blueGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
