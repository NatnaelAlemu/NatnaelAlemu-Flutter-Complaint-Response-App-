import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/Blocs/complaint/complaint_bloc.dart';
import 'package:frontend/Blocs/login/login_bloc.dart';
import 'package:frontend/customWidgets/widgets.dart';
import 'package:frontend/models/models.dart';


class AddComplaint extends StatelessWidget {
  AddComplaint({Key? key}) : super(key: key);
  static const String routeName = "/addcomplaint";
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    String _id = "";
    var loggedinState = BlocProvider.of<LoginBloc>(context).state;
    if (loggedinState is LoggedIn) {
      _id = loggedinState.user.id!;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add your Complaint",
          style: TextStyle(
              fontSize: 25, fontFamily: 'Merienda', color: Colors.deepPurple),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              "assets/images/background.png",
              fit: BoxFit.cover,
            ),
          ),
          ListView(children: [
            SizedBox(height: MediaQuery.of(context).size.height / 3),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Submit Your Complaint",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Merienda',
                  color: Colors.lightGreen,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(children: [
                FormTextField(
                  obscureText: false,
                  controller: titleController,
                  hintText: "title",
                  prefix: Icon(Icons.title),
                  whenEmpty: "this field is required",
                ),
                FormTextField(
                  controller: descriptionController,
                  hintText: "description",
                  whenEmpty: "this field is required",
                  prefix: Icon(Icons.description),
                ),
                FormButton(
                  color: Colors.deepPurple,
                  buttonLabel: "Submit",
                  onpressed: () {
                    var form = _formKey.currentState;
                    if (form!.validate()) {
                      var complaint = Complaint(
                          titleController.text, descriptionController.text,
                          madeby: _id,
                          seen: false,
                          fixed: false,
                          );
                      BlocProvider.of<ComplaintBloc>(context)
                          .add(CreateComplaint(complaint));
                    }
                  },
                ),
              ]),
            ),
            SizedBox(
              height: 30,
            ),
            BlocConsumer<ComplaintBloc, ComplaintState>(
                listener: (contex, state) {
              if (state is CrudOperationsSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green,
                    content: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'Pacifico', fontSize: 20),
                    ),
                  ),
                );
                titleController.text = "";
                descriptionController.text = "";
                Navigator.pop(context);
              }
            }, builder: (_, state) {
              if (state is ComplaintsLoading) {
                return SpinKitSpinningLines(
                  color: Colors.deepPurple,
                  size: 60,
                );
              }
              if (state is FailedComplaintsCrud) {
                return Text(
                  state.message,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                );
              }
              return Container();
            }),
          ]),
        ],
      ),
    );
  }
}
