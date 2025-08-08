import 'dart:convert';

class TeamMovementResponse {
  final String status;
  final String message;
  final TeamData data;

  TeamMovementResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TeamMovementResponse.fromJson(Map<String, dynamic> json) {
    return TeamMovementResponse(
      status: json['status'],
      message: json['message'],
      data: TeamData.fromJson(json['data']),
    );
  }
}

/// Contiene el objeto `team` y la lista `items`
class TeamData {
  final Team team;
  final List<TeamMovement> items;

  TeamData({
    required this.team,
    required this.items,
  });

  factory TeamData.fromJson(Map<String, dynamic> json) {
    return TeamData(
      team: Team.fromJson(json['team']),
      items: (json['items'] as List)
          .map((e) => TeamMovement.fromJson(e))
          .toList(),
    );
  }
}

/// Objeto `team` del JSON
class Team {
  final int id;
  final String code;
  final String description;
  final int stock;
  final String stateCalibration;
  final bool state;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Team({
    required this.id,
    required this.code,
    required this.description,
    required this.stock,
    required this.stateCalibration,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      code: json['code'],
      description: json['description'],
      stock: json['stock'],
      stateCalibration: json['state_calibration'],
      state: json['state'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

/// Objeto de la lista `items`
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

/// Objeto `movement` dentro de cada `item`
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
