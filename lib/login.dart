import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final nameController = TextEditingController();
  final salaryController = TextEditingController();
  final ageController = TextEditingController();



  bool isLoading = false;
  int? userId ;

  Future<http.Response> submitDetails(String name, String salary, String age) async {
    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('https://dummy.restapiexample.com/api/v1/create'),
      body: {
        "name": name,
        "salary": salary,
        "age": age,
      },
    );

    setState(() {
      isLoading = false;
    });

    return response;
  }

  void handleSubmit() async {
    final name = nameController.text;
    final salary = int.parse(salaryController.text) ?? 0;
    final age = int.parse(ageController.text) ?? 0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter name')),
      );
    } else if (salary == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter salary')),
      );
    } else if (age == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter age')),
      );
    } else {
      final response = await submitDetails(name, salary.toString(), age.toString());
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('SUCCESS: ${data['message']}')),

        );

        print(data['data']);
        setState(() {
          userId = data['data']['id']; // Set the userId here
        });

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ERROR: Something went wrong')),
        );
      }
    }
  }

  Future<http.Response> updateDetails(String name, String salary, String age) async {

    setState(() {
      isLoading = true;
    });

    final response1 = await http.post(
      Uri.parse('https://dummy.restapiexample.com/api/v1/update/$userId'),
      body: {
        "name": name,
        "salary": salary,
        "age": age,
      },
    );

    setState(() {
      isLoading = false;
    });

    print(response1.body);


    return response1;
  }

  void handleUpdate() async {
    final response1 = await updateDetails(nameController.text, salaryController.text, ageController.text);
    final data1 = jsonDecode(response1.body);

    if (response1.statusCode == 200 && data1['status'] == 'success') {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text( data1['message'])),
      );


      nameController.clear();
      salaryController.clear();
      ageController.clear();


    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ERROR: Something went wrong')),
      );
    }

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                "Enter your details",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.deepOrange),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]'))
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Enter name",
                  hintStyle: const TextStyle(
                    color: Color(0xff555555),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.08),
                  ),
                  fillColor: const Color(0xFFF1F3F6),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: salaryController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.deepOrange),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Enter salary",
                  hintStyle: const TextStyle(
                    color: Color(0xff555555),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.08),
                  ),
                  fillColor: const Color(0xFFF1F3F6),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.deepOrange),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  LengthLimitingTextInputFormatter(3),
                ],
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                  hintText: "Enter age",
                  hintStyle: const TextStyle(
                    color: Color(0xff555555),
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(8.08),
                  ),
                  fillColor: const Color(0xFFF1F3F6),
                ),
              ),

              const SizedBox(height: 100),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    handleSubmit();

                  },
                  child: const Text(
                    "Enter Data",
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                    shadowColor: Colors.deepOrangeAccent.withOpacity(.50),
                    elevation: 20,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: handleUpdate,
                  child: const Text(
                    "update data",
                    style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    backgroundColor: Colors.deepOrangeAccent,
                    shadowColor: Colors.deepOrangeAccent.withOpacity(.50),
                    elevation: 20,
                  ),
                ),
              ),

            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

