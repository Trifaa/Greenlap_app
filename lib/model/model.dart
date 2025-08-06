import 'dart:convert';

class TeamMovement {
  final int id;
  final int movementId;
  final int teamId;
  final int amount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Movement movement;

  TeamMovement({
    required this.id,
    required this.movementId,
    required this.teamId,
    required this.amount,
    required this.createdAt,
    required this.updatedAt,
    required this.movement,
  });

  factory TeamMovement.fromJson(Map<String, dynamic> json) {
    return TeamMovement(
      id: json['id'],
      movementId: json['movement_id'],
      teamId: json['team_id'],
      amount: json['amount'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      movement: Movement.fromJson(json['movement']),
    );
  }
}


class Movement {
  final int id;
  final int companyId;
  final int userId;
  final String? deliveryDate;
  final String? returnDate;
  final String? status;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Movement({
    required this.id,
    required this.companyId,
    required this.userId,
    this.deliveryDate,
    this.returnDate,
    this.status,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Movement.fromJson(Map<String, dynamic> json) {
    return Movement(
      id: json['id'],
      companyId: json['company_id'],
      userId: json['user_id'],
      deliveryDate: json['delivery_date'],
      returnDate: json['return_date'],
      status: json['status'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'])
          : null,
    );
  }
}
