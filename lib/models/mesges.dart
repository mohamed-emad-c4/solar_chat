import 'dart:math';

class MesgesFirestore {
  final String modelDevice;
  final String message;
  final String time;
  final String email;
  MesgesFirestore({required this.modelDevice, required this.message, required this.time, required this.email});

  factory MesgesFirestore.fromJson( json) {
    return MesgesFirestore(
      modelDevice: json['device-model'],
      message: json['send-message'],
      time: json['time-send'],
      email: json['email'],
    );
  }
  
}