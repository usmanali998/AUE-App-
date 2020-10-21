import 'dart:convert';
import 'dart:typed_data';

import 'package:aue/model/whatsapp_contact_model.dart';
import 'package:aue/notifiers/auth_notifier.dart';
import 'package:aue/res/res.dart';
import 'package:aue/services/repository.dart';
import 'package:aue/widgets/custom_widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactsTab extends StatefulWidget {
  @override
  _ContactsTabState createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  Future<List<WhatsAppContact>> _whatsAppContactsFuture;

  void getWhatsAppContacts() {
    _whatsAppContactsFuture = null;
    String studentId = context.read<AuthNotifier>().user.studentID;
    _whatsAppContactsFuture = Repository().getWhatsAppContacts(studentId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    this.getWhatsAppContacts();
  }

  @override
  Widget build(BuildContext context) {
    return SecondaryBackgroundWidget(
      title: 'Contacts',
      image: Images.classUpdates,
      showBackButton: true,
      child: Expanded(
        child: FutureBuilder<List<WhatsAppContact>>(
          future: _whatsAppContactsFuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<WhatsAppContact>> snapshot) {
            if (snapshot.isLoading) {
              return LoadingWidget();
            }
            if (snapshot.hasError && snapshot.error != null) {
              return CustomErrorWidget(
                err: DioError(
                  error: snapshot.error,
                  type: DioErrorType.RESPONSE,
                  response: Response<String>(data: snapshot.error),
                ),
                onRetryTap: () => this.getWhatsAppContacts(),
              );
            }
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 7.0,
                childAspectRatio: 0.9,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ContactCard(
                  title: snapshot.data[index].nameEn,
                  image: base64Decode(snapshot.data[index].icon),
                  icon: Icons.phonelink,
                  backgroundColor: Color.fromRGBO(125, 187, 227, 1.0),
                  phoneNumber: snapshot.data[index].number,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  final Color backgroundColor;
  final Uint8List image;
  final String title;
  final String phoneNumber;
  final IconData icon;

  const ContactCard({
    this.backgroundColor,
    this.image,
    this.phoneNumber,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch('whatsapp://send?phone=$phoneNumber')) {
          await launch('whatsapp://send?phone=$phoneNumber');
        }
      },
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(12.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(15.0),
                margin: const EdgeInsets.only(top: 10.0),
                decoration: BoxDecoration(
                  color: this.backgroundColor,
                  borderRadius:
                      const BorderRadius.all(const Radius.circular(12.0)),
                ),
                child: Image.memory(
                  this.image,
                  fit: BoxFit.contain,
                  // width: DS.width * 0.1,
                  // height: DS.height * 0.1,
                ),
                // child: this.image == null
                //     ? Icon(
                //         this.icon,
                //         color: Colors.white,
                //         size: 40,
                //       )
                //     : Image.asset(
                //         this.image,
                //         fit: BoxFit.contain,
                //       ),
              ),
            ),
            SizedBox(height: DS.height * 0.02),
            Visibility(
              visible: false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: Text(
                  this.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.blackGrey,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: AutoSizeText(
                  this.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.blackGrey,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: DS.height * 0.03),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0).add(const EdgeInsets.only(bottom: 10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Images.whatsApp,
                    ),
                    // Icon(
                    //   Icons.whatshot,
                    //   color: Colors.green,
                    // ),
                    const SizedBox(width: 4.0),
                    Text(
                      this.phoneNumber,
                      style: const TextStyle(
                        color: AppColors.blueGrey,
                        fontSize: 12.0
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
