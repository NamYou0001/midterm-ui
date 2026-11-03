# Restaurant Manager

A Flutter mobile app using GetX, JWT authentication, REST repositories, and a
clean employee/product management UI.

## Features

- JWT login/logout with the token persisted in `SharedPreferences`
- Product listing from `GET /products`
- Employee listing from `GET /users`
- Employee create, update, and confirmed delete actions
- GetX controllers, reactive loading/error states, and named navigation
- Form validation and loading indicators

## Run

```bash
flutter pub get
flutter run
```

The app defaults to `http://169.58.63.127:3333/`. The backend should expose:

- `POST /auth/login` returning `accessToken` (or `token`)
- `GET /products`
- `GET /users`
- `POST /users/add`
- `PUT /users/:id`
- `DELETE /users/:id`

The repository layer maps the API payloads to app models, so the endpoint
paths and JSON mapping can be adjusted without changing the UI.
