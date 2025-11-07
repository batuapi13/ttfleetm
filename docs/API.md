# API Documentation

## Overview

The TT Fleet Management System provides a RESTful API for managing vehicles, users, usage tracking, and authentication. All API endpoints require proper authentication and return JSON responses.

## Base URL
```
http://localhost:3000/api
```

## Authentication

### Session-based Authentication
The API uses session-based authentication with cookies. Users must login to obtain a session.

### Admin Elevation
Some operations require admin privileges. The system supports admin password verification for privilege escalation.

## API Endpoints

### Authentication Endpoints

#### POST /api/login
Authenticate user and create session.

**Request Body:**
```json
{
  "username": "string",
  "password": "string"
}
```

**Response (Success):**
```json
{
  "user": {
    "id": "string",
    "username": "string",
    "role": "admin|user",
    "displayName": "string"
  }
}
```

**Response (Error):**
```json
{
  "error": "Invalid credentials"
}
```

#### POST /api/logout
Terminate user session.

**Response:**
```json
{
  "message": "Logged out successfully"
}
```

#### GET /api/me
Get current user information.

**Response:**
```json
{
  "user": {
    "id": "string",
    "username": "string",
    "role": "admin|user",
    "displayName": "string"
  }
}
```

#### POST /api/admin/elevate
Verify admin password for privilege escalation.

**Request Body:**
```json
{
  "password": "string"
}
```

**Response (Success):**
```json
{
  "elevated": true
}
```

### Vehicle Endpoints

#### GET /api/vehicles
Get list of all vehicles.

**Response:**
```json
[
  {
    "id": "string",
    "registration": "string",
    "make": "string",
    "model": "string",
    "year": "number",
    "mileage": "number",
    "status": "available|in_use|maintenance",
    "current_user_id": "string|null",
    "current_user_name": "string|null"
  }
]
```

#### POST /api/vehicles
Create new vehicle. **(Admin only)**

**Request Body:**
```json
{
  "registration": "string",
  "make": "string",
  "model": "string",
  "year": "number",
  "mileage": "number"
}
```

**Response:**
```json
{
  "id": "string",
  "registration": "string",
  "make": "string",
  "model": "string",
  "year": "number",
  "mileage": "number",
  "status": "available"
}
```

#### PUT /api/vehicles/:id
Update vehicle information. **(Admin only)**

**Request Body:**
```json
{
  "registration": "string",
  "make": "string", 
  "model": "string",
  "year": "number",
  "mileage": "number"
}
```

#### DELETE /api/vehicles/:id
Delete vehicle. **(Admin only)**

**Response:**
```json
{
  "message": "Vehicle deleted successfully"
}
```

#### POST /api/vehicles/:id/use
Check out vehicle for use.

**Request Body:**
```json
{
  "mileage_before": "number",
  "notes": "string"
}
```

**Response:**
```json
{
  "message": "Vehicle checked out successfully",
  "usage_id": "string"
}
```

#### POST /api/vehicles/:id/return
Check in vehicle after use.

**Request Body:**
```json
{
  "mileage_after": "number",
  "notes": "string"
}
```

**Response:**
```json
{
  "message": "Vehicle checked in successfully"
}
```

### Usage Tracking Endpoints

#### GET /api/usage
Get usage history.

**Query Parameters:**
- `vehicle_id` (optional): Filter by vehicle
- `user_id` (optional): Filter by user
- `limit` (optional): Limit number of results
- `offset` (optional): Pagination offset

**Response:**
```json
[
  {
    "id": "string",
    "vehicle_id": "string",
    "user_id": "string",
    "user_name": "string",
    "vehicle_registration": "string",
    "checkout_time": "ISO 8601 string",
    "checkin_time": "ISO 8601 string|null",
    "mileage_before": "number",
    "mileage_after": "number|null",
    "distance_traveled": "number|null",
    "checkout_notes": "string",
    "checkin_notes": "string",
    "status": "active|completed"
  }
]
```

#### GET /api/usage/:id
Get specific usage record.

**Response:**
```json
{
  "id": "string",
  "vehicle_id": "string",
  "user_id": "string",
  "user_name": "string",
  "vehicle_registration": "string",
  "checkout_time": "ISO 8601 string",
  "checkin_time": "ISO 8601 string|null",
  "mileage_before": "number",
  "mileage_after": "number|null",
  "distance_traveled": "number|null",
  "checkout_notes": "string",
  "checkin_notes": "string",
  "status": "active|completed"
}
```

### User Management Endpoints

#### GET /api/users
Get list of users. **(Admin only)**

**Response:**
```json
[
  {
    "id": "string",
    "username": "string",
    "role": "admin|user",
    "displayName": "string",
    "email": "string",
    "created_at": "ISO 8601 string",
    "last_login": "ISO 8601 string"
  }
]
```

#### POST /api/users
Create new user. **(Admin only)**

**Request Body:**
```json
{
  "username": "string",
  "password": "string",
  "role": "admin|user",
  "displayName": "string",
  "email": "string"
}
```

**Response:**
```json
{
  "id": "string",
  "username": "string",
  "role": "admin|user",
  "displayName": "string",
  "email": "string",
  "created_at": "ISO 8601 string"
}
```

#### PUT /api/users/:id
Update user information. **(Admin only)**

**Request Body:**
```json
{
  "role": "admin|user",
  "displayName": "string",
  "email": "string"
}
```

#### DELETE /api/users/:id
Delete user. **(Admin only)**

**Response:**
```json
{
  "message": "User deleted successfully"
}
```

#### POST /api/users/:id/change-password
Change user password. **(Own account or Admin)**

**Request Body:**
```json
{
  "currentPassword": "string",
  "newPassword": "string"
}
```

### Maintenance Endpoints

#### GET /api/maintenance
Get maintenance records.

**Query Parameters:**
- `vehicle_id` (optional): Filter by vehicle

**Response:**
```json
[
  {
    "id": "string",
    "vehicle_id": "string",
    "vehicle_registration": "string",
    "type": "string",
    "description": "string",
    "date": "ISO 8601 string",
    "mileage": "number",
    "cost": "number",
    "service_provider": "string",
    "notes": "string",
    "created_by": "string",
    "created_at": "ISO 8601 string"
  }
]
```

#### POST /api/maintenance
Create maintenance record. **(Admin only)**

**Request Body:**
```json
{
  "vehicle_id": "string",
  "type": "string",
  "description": "string",
  "date": "ISO 8601 string",
  "mileage": "number",
  "cost": "number",
  "service_provider": "string",
  "notes": "string"
}
```

#### PUT /api/maintenance/:id
Update maintenance record. **(Admin only)**

**Request Body:**
```json
{
  "type": "string",
  "description": "string",
  "date": "ISO 8601 string", 
  "mileage": "number",
  "cost": "number",
  "service_provider": "string",
  "notes": "string"
}
```

#### DELETE /api/maintenance/:id
Delete maintenance record. **(Admin only)**

### Document Endpoints

#### GET /api/documents
Get document list. **(Admin only)**

**Response:**
```json
[
  {
    "id": "string",
    "vehicle_id": "string|null",
    "title": "string",
    "type": "string",
    "filename": "string",
    "file_path": "string",
    "file_size": "number",
    "mime_type": "string",
    "uploaded_by": "string",
    "uploaded_at": "ISO 8601 string",
    "description": "string"
  }
]
```

#### POST /api/documents
Upload document. **(Admin only)**

**Request (multipart/form-data):**
```
file: File
vehicle_id: string (optional)
title: string
type: string
description: string
```

**Response:**
```json
{
  "id": "string",
  "title": "string",
  "filename": "string",
  "file_size": "number",
  "uploaded_at": "ISO 8601 string"
}
```

#### GET /api/documents/:id/download
Download document file. **(Admin only)**

**Response:** File download

#### DELETE /api/documents/:id
Delete document. **(Admin only)**

### Dashboard Endpoints

#### GET /api/dashboard/stats
Get dashboard statistics.

**Response:**
```json
{
  "total_vehicles": "number",
  "vehicles_in_use": "number",
  "vehicles_available": "number",
  "vehicles_maintenance": "number",
  "total_users": "number",
  "active_usage_sessions": "number",
  "total_distance_this_month": "number",
  "maintenance_due_soon": "number"
}
```

#### GET /api/dashboard/recent-activity
Get recent activity feed.

**Response:**
```json
[
  {
    "id": "string",
    "type": "checkout|checkin|maintenance|user_created",
    "description": "string",
    "user": "string",
    "vehicle": "string",
    "timestamp": "ISO 8601 string"
  }
]
```

## Error Responses

All endpoints may return the following error responses:

### 401 Unauthorized
```json
{
  "error": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Insufficient permissions"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

### 400 Bad Request
```json
{
  "error": "Invalid input data",
  "details": {
    "field": "error description"
  }
}
```

### 500 Internal Server Error
```json
{
  "error": "Internal server error"
}
```

## Rate Limiting

API endpoints are rate limited to prevent abuse:
- **100 requests per 15 minutes** per IP address
- **Rate limit headers** included in responses:
  - `X-RateLimit-Limit`: Request limit
  - `X-RateLimit-Remaining`: Remaining requests
  - `X-RateLimit-Reset`: Reset time

## CORS

Cross-Origin Resource Sharing (CORS) is configured to allow requests from:
- Same origin (default)
- Configured allowed origins in server configuration

## Data Validation

All API endpoints perform input validation:
- **Required fields** must be provided
- **Data types** must match specification
- **String lengths** are validated
- **Email formats** are validated where applicable
- **Numeric ranges** are checked

## Security Considerations

1. **HTTPS recommended** for production deployments
2. **Session cookies** are secure and httpOnly
3. **Input sanitization** prevents XSS attacks
4. **SQL injection protection** (N/A - uses JSON storage)
5. **File upload restrictions** limit file types and sizes
6. **Admin operations** require privilege escalation

## Example Usage

### JavaScript/Fetch Example
```javascript
// Login
const response = await fetch('/api/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    username: 'admin',
    password: 'admin123'
  })
});

const data = await response.json();
console.log('User:', data.user);

// Get vehicles
const vehiclesResponse = await fetch('/api/vehicles');
const vehicles = await vehiclesResponse.json();
console.log('Vehicles:', vehicles);
```

### cURL Examples
```bash
# Login
curl -X POST http://localhost:3000/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}' \
  -c cookies.txt

# Get vehicles (using saved cookies)
curl -X GET http://localhost:3000/api/vehicles \
  -b cookies.txt

# Create vehicle (admin only)
curl -X POST http://localhost:3000/api/vehicles \
  -H "Content-Type: application/json" \
  -b cookies.txt \
  -d '{"registration":"ABC123","make":"Toyota","model":"Camry","year":2022,"mileage":15000}'
```

## Webhooks (Future Feature)

Planned webhook support for:
- Vehicle status changes
- Maintenance reminders
- User activity notifications
- System alerts

## SDK Libraries (Planned)

Future SDK libraries for:
- JavaScript/TypeScript
- Python
- PHP
- .NET