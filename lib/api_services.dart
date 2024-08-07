import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiServices {
  Future <dynamic> getUserDetails() async {
   String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOjEsImlhdCI6MTcyMDg2MzQxMywiZXhwIjoxNzIyNTkxNDEzfQ.lrpvhH-jZ3EaXVJDd5PCghadHIo--qga5XU_0BgVvpU';
    var reponse = await http.get(Uri.parse('https://api.escuelajs.co/api/v1/auth/profile'),
    headers: {
     'Authorization': "Bearer $token"
        }
    );

    if (reponse.statusCode==200){
     return jsonDecode(reponse.body);
    }
    else {
     return null ;
    }
}
}