# 🟦 THỰC HÀNH CHƯƠNG 14: CLEAN ARCHITECTURE TRONG FLUTTER

> **📌 DÀNH CHO NGƯỜI ĐÃ CÓ KINH NGHIỆM**
> 
> Bài thực hành này hướng dẫn cách tổ chức code theo Clean Architecture để dự án dễ maintain và scale.
> 
> **🔗 LIÊN KẾT:** Bài này sẽ refactor dự án Book Management từ [Bài 10b - Dự án Tổng hợp](../10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) lên Clean Architecture.

---

## 🎯 MỤC TIÊU

Sau bài này, bạn sẽ:
- ✅ Hiểu nguyên tắc Clean Architecture
- ✅ So sánh được cấu trúc Feature-based vs Clean Architecture
- ✅ Refactor dự án từ Bài 10 lên Clean Architecture
- ✅ Tổ chức code theo layers (Presentation, Domain, Data)
- ✅ Tách biệt business logic và UI
- ✅ Sử dụng Dependency Injection

---

## 📋 CHECKLIST CHUẨN BỊ

Trước khi bắt đầu, đảm bảo bạn có:
- [ ] Đã hoàn thành [Bài 10b - Dự án Tổng hợp: Bloc + Provider + .NET API](../10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) (hoặc có dự án tương tự)
- [ ] Kiến thức về Flutter cơ bản
- [ ] Hiểu về State Management (Provider/Bloc)
- [ ] Kiến thức về API và Repository pattern

---

## 🔗 MỐI LIÊN KẾT VỚI BÀI 10

### Dự án Book Management

**Bài 10** đã xây dựng ứng dụng Book Management với:
- ✅ .NET Web API backend
- ✅ Flutter app với Bloc + Provider
- ✅ Cấu trúc Feature-based (models, services, blocs, screens)

**Bài 14** sẽ:
- 🔄 **Refactor** dự án đó lên Clean Architecture
- 📐 Tách biệt rõ ràng: Domain, Data, Presentation
- 🧪 Làm cho code dễ test hơn
- 🚀 Làm cho code chuyên nghiệp và scalable hơn

### So sánh cấu trúc

**Bài 10 - Cấu trúc hiện tại (Feature-based):**
```
lib/
├── models/
│   └── book.dart
├── services/
│   └── api_service.dart
├── providers/
│   ├── auth_provider.dart
│   └── theme_provider.dart
├── blocs/
│   └── book/
│       ├── book_event.dart
│       ├── book_state.dart
│       └── book_bloc.dart
├── screens/
│   ├── login_screen.dart
│   ├── home_screen.dart
│   └── book_list_screen.dart
└── widgets/
    └── book_card.dart
```

**Bài 14 - Clean Architecture (Layer-based):**
```
lib/
├── core/
│   ├── constants/
│   ├── errors/
│   └── utils/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── books/
│       ├── data/
│       │   ├── datasources/
│       │   ├── models/
│       │   └── repositories/
│       ├── domain/
│       │   ├── entities/
│       │   ├── repositories/
│       │   └── usecases/
│       └── presentation/
│           ├── bloc/
│           ├── pages/
│           └── widgets/
└── injection/
    └── injection_container.dart
```

### Tại sao cần refactor?

**Vấn đề của cấu trúc Bài 10:**
- ⚠️ **Logic nghiệp vụ lẫn với UI:** Bloc gọi trực tiếp ApiService
- ⚠️ **Khó test:** Không thể test logic độc lập với API
- ⚠️ **Khó thay đổi:** Muốn đổi từ API sang Local DB phải sửa nhiều nơi
- ⚠️ **Khó mở rộng:** Thêm feature mới làm rối code cũ

**Lợi ích Clean Architecture:**
- ✅ **Tách biệt rõ ràng:** Domain không phụ thuộc Framework
- ✅ **Dễ test:** Test từng layer độc lập
- ✅ **Dễ thay đổi:** Đổi API → Local DB chỉ sửa Data layer
- ✅ **Dễ mở rộng:** Thêm feature mới không ảnh hưởng code cũ

---

---

## BÀI TẬP 1: CẤU TRÚC CLEAN ARCHITECTURE

### Mục đích
Hiểu cấu trúc Clean Architecture và so sánh với cấu trúc Bài 10.

### Yêu cầu

1. **Tạo cấu trúc thư mục Clean Architecture:**

**Từ dự án Bài 10, tạo cấu trúc mới:**
```
lib/
├── main.dart
├── core/                    # Core functionality (shared)
│   ├── constants/
│   │   └── api_constants.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── utils/
│       └── network_info.dart
├── features/                # Features (modules)
│   ├── auth/               # Feature: Authentication
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── books/              # Feature: Book Management (từ Bài 10)
│       ├── data/           # Data layer
│       │   ├── datasources/
│       │   │   ├── book_remote_data_source.dart
│       │   │   └── book_local_data_source.dart (tùy chọn)
│       │   ├── models/
│       │   │   └── book_model.dart (từ models/book.dart)
│       │   └── repositories/
│       │       └── book_repository_impl.dart
│       ├── domain/         # Domain layer (Business logic)
│       │   ├── entities/
│       │   │   └── book.dart (pure Dart, không phụ thuộc framework)
│       │   ├── repositories/
│       │   │   └── book_repository.dart (interface)
│       │   └── usecases/
│       │       ├── get_books.dart
│       │       ├── create_book.dart
│       │       ├── update_book.dart
│       │       └── delete_book.dart
│       └── presentation/   # Presentation layer (UI)
│           ├── bloc/
│           │   ├── book_event.dart (từ blocs/book/)
│           │   ├── book_state.dart (từ blocs/book/)
│           │   └── book_bloc.dart (từ blocs/book/, refactor)
│           ├── pages/
│           │   ├── book_list_page.dart (từ screens/book_list_screen.dart)
│           │   └── book_form_page.dart (từ screens/book_form_screen.dart)
│           └── widgets/
│               └── book_card.dart (từ widgets/)
└── injection/              # Dependency injection
    └── injection_container.dart
```

2. **Tạo file core:**
Tạo `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const String productsEndpoint = '/products';
}
```

Tạo `lib/core/errors/failures.dart`:
```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}
```

### Kết quả mong đợi
- Hiểu cấu trúc Clean Architecture
- Tạo được cấu trúc thư mục chuẩn

---

## BÀI TẬP 2: DOMAIN LAYER (REFACTOR TỪ BÀI 10)

### Mục đích
Tạo Domain layer từ code của Bài 10. Domain layer không phụ thuộc vào framework, chỉ chứa business logic.

### Yêu cầu

**Bước 1: Tạo Entity (Từ Model của Bài 10)**

1. **Tạo Entity:**
Tạo `lib/features/books/domain/entities/book.dart`:

**So sánh với Bài 10:**
- **Bài 10:** `models/book.dart` - Có `fromJson/toJson` (phụ thuộc JSON)
- **Clean Architecture:** `entities/book.dart` - Pure Dart class (không phụ thuộc)

```dart
// Entity: Pure Dart class, không phụ thuộc framework
class Book {
  final int id;
  final String title;
  final String author;
  final String isbn;
  final DateTime publishedDate;
  final int pageCount;
  final String? description;
  final DateTime createdAt;
  
  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.isbn,
    required this.publishedDate,
    required this.pageCount,
    this.description,
    required this.createdAt,
  });
  
  // Không có fromJson/toJson ở đây!
  // Entity không biết về JSON, chỉ biết về business logic
}
```

**Lưu ý:** Entity khác với Model:
- **Entity:** Pure Dart, không phụ thuộc framework (Domain layer)
- **Model:** Có `fromJson/toJson`, phụ thuộc JSON (Data layer)
```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String? description;
  
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
  });
}
```

2. **Tạo Repository Interface:**
Tạo `lib/features/books/domain/repositories/book_repository.dart`:

**So sánh với Bài 10:**
- **Bài 10:** Bloc gọi trực tiếp `ApiService.getBooks()`
- **Clean Architecture:** Bloc gọi `UseCase`, UseCase gọi `Repository` (interface)

```dart
import '../entities/book.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart'; // Package cho Either

abstract class BookRepository {
  // Repository là interface, không có implementation ở đây
  Future<Either<Failure, List<Book>>> getBooks();
  Future<Either<Failure, Book>> getBook(int id);
  Future<Either<Failure, Book>> createBook(Book book);
  Future<Either<Failure, Book>> updateBook(Book book);
  Future<Either<Failure, void>> deleteBook(int id);
}
```

**Lưu ý:**
- Repository là **interface** (abstract class)
- Implementation sẽ ở Data layer
- Dùng `Either<Failure, T>` để xử lý error (thay vì try-catch)

3. **Cài đặt package `dartz`:**
```yaml
dependencies:
  dartz: ^0.10.1  # Cho Either<Failure, T>
```

4. **Tạo Use Case:**
Tạo `lib/features/books/domain/usecases/get_books.dart`:

**So sánh với Bài 10:**
- **Bài 10:** `BookBloc._onLoadBooks()` gọi trực tiếp `ApiService.getBooks()`
- **Clean Architecture:** `BookBloc` gọi `GetBooks` UseCase, UseCase gọi Repository

```dart
import '../entities/book.dart';
import '../repositories/book_repository.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class GetBooks {
  final BookRepository repository;
  
  GetBooks(this.repository);
  
  // UseCase đại diện cho 1 business operation
  Future<Either<Failure, List<Book>>> call() {
    return repository.getBooks();
  }
}

// Tương tự cho các UseCase khác
class CreateBook {
  final BookRepository repository;
  
  CreateBook(this.repository);
  
  Future<Either<Failure, Book>> call(Book book) {
    return repository.createBook(book);
  }
}

class UpdateBook {
  final BookRepository repository;
  
  UpdateBook(this.repository);
  
  Future<Either<Failure, Book>> call(Book book) {
    return repository.updateBook(book);
  }
}

class DeleteBook {
  final BookRepository repository;
  
  DeleteBook(this.repository);
  
  Future<Either<Failure, void>> call(int id) {
    return repository.deleteBook(id);
  }
}
```

**Giải thích:**
- **UseCase** đại diện cho 1 business operation cụ thể
- Mỗi UseCase chỉ làm 1 việc (Single Responsibility)
- Dễ test: Test UseCase độc lập với Repository

### Kết quả mong đợi
- Tạo được Domain layer
- Hiểu về entities, repositories, use cases

---

## BÀI TẬP 3: DATA LAYER (REFACTOR TỪ BÀI 10)

### Mục đích
Refactor Data layer từ code của Bài 10. Data layer chứa models, data sources, và repository implementations.

### Yêu cầu

**Bước 1: Tạo Core Errors**

1. **Tạo file `lib/core/errors/failures.dart`:**
```dart
abstract class Failure {
  final String message;
  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String message) : super(message);
}
```

2. **Tạo file `lib/core/errors/exceptions.dart`:**
```dart
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
}

class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
```

**Bước 2: Tạo Model (Refactor từ Bài 10)**

**So sánh với Bài 10:**
- **Bài 10:** `models/book.dart` - Có cả Entity và JSON serialization
- **Clean Architecture:** Tách riêng Entity và Model

1. **Tạo Model:**
Tạo `lib/features/books/data/models/book_model.dart`:

**Di chuyển từ `lib/models/book.dart` (Bài 10) sang đây và refactor:**
```dart
import '../../domain/entities/book.dart';
import 'dart:convert';

// Model extends Entity và có JSON serialization
class BookModel extends Book {
  BookModel({
    required int id,
    required String title,
    required String author,
    required String isbn,
    required DateTime publishedDate,
    required int pageCount,
    String? description,
    required DateTime createdAt,
  }) : super(
          id: id,
          title: title,
          author: author,
          isbn: isbn,
          publishedDate: publishedDate,
          pageCount: pageCount,
          description: description,
          createdAt: createdAt,
        );
  
  // JSON serialization ở Model layer (không ở Entity)
  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
      isbn: json['isbn'] as String,
      publishedDate: DateTime.parse(json['publishedDate'] as String),
      pageCount: json['pageCount'] as int,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'isbn': isbn,
      'publishedDate': publishedDate.toIso8601String(),
      'pageCount': pageCount,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }
  
  // Convert Model → Entity (để trả về Domain layer)
  Book toEntity() {
    return Book(
      id: id,
      title: title,
      author: author,
      isbn: isbn,
      publishedDate: publishedDate,
      pageCount: pageCount,
      description: description,
      createdAt: createdAt,
    );
  }
  
  // Copy từ Entity (khi nhận từ Domain layer)
  // Note: Có thể tạo factory constructor hoặc method static
  static BookModel fromEntity(Book book) {
    return BookModel(
      id: book.id,
      title: book.title,
      author: book.author,
      isbn: book.isbn,
      publishedDate: book.publishedDate,
      pageCount: book.pageCount,
      description: book.description,
      createdAt: book.createdAt,
    );
  }
}
```

**Bước 3: Tạo Data Source (Refactor từ ApiService của Bài 10)**

**So sánh với Bài 10:**
- **Bài 10:** `ApiService` - Class tĩnh, chứa tất cả API calls
- **Clean Architecture:** `BookRemoteDataSource` - Interface + Implementation, mỗi feature có data source riêng

1. **Tạo Core Constants:**
Tạo `lib/core/constants/api_constants.dart`:
```dart
class ApiConstants {
  // Di chuyển baseUrl từ ApiService của Bài 10
  static String get baseUrl {
    // Logic chọn URL (từ ApiService của Bài 10)
    return 'http://localhost:5000/api';
  }
  
  static const String booksEndpoint = '/books';
}
```

2. **Tạo Data Source Interface:**
Tạo `lib/features/books/data/datasources/book_remote_data_source.dart`:

**Refactor từ `lib/services/api_service.dart` (Bài 10):**
```dart
import '../models/book_model.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class BookRemoteDataSource {
  Future<List<BookModel>> getBooks();
  Future<BookModel> getBook(int id);
  Future<BookModel> createBook(BookModel book);
  Future<BookModel> updateBook(BookModel book);
  Future<void> deleteBook(int id);
}

class BookRemoteDataSourceImpl implements BookRemoteDataSource {
  final http.Client client;
  
  BookRemoteDataSourceImpl({required this.client});
  
  @override
  Future<List<BookModel>> getBooks() async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}');
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => BookModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to load books: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<BookModel> getBook(int id) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}/$id');
      final response = await client.get(url).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode == 200) {
        return BookModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        throw ServerException('Book not found');
      } else {
        throw ServerException('Failed to load book: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<BookModel> createBook(BookModel book) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}');
      final response = await client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(book.toJson()),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 201) {
        return BookModel.fromJson(jsonDecode(response.body));
      } else {
        throw ServerException('Failed to create book: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<BookModel> updateBook(BookModel book) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}/${book.id}');
      final response = await client.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(book.toJson()),
      ).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200 || response.statusCode == 204) {
        return book; // Server trả về NoContent
      } else {
        throw ServerException('Failed to update book: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
  
  @override
  Future<void> deleteBook(int id) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.booksEndpoint}/$id');
      final response = await client.delete(url).timeout(
        const Duration(seconds: 10),
      );
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException('Failed to delete book: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
```

**Bước 4: Tạo Repository Implementation**

**So sánh với Bài 10:**
- **Bài 10:** Không có Repository, Bloc gọi trực tiếp ApiService
- **Clean Architecture:** Repository Implementation làm cầu nối giữa Domain và Data

3. **Tạo Repository Implementation:**
Tạo `lib/features/books/data/repositories/book_repository_impl.dart`:
```dart
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';
import '../datasources/book_remote_data_source.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class BookRepositoryImpl implements BookRepository {
  final BookRemoteDataSource remoteDataSource;
  
  BookRepositoryImpl({required this.remoteDataSource});
  
  @override
  Future<Either<Failure, List<Book>>> getBooks() async {
    try {
      final models = await remoteDataSource.getBooks();
      // Convert Model → Entity
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Book>> getBook(int id) async {
    try {
      final model = await remoteDataSource.getBook(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Book>> createBook(Book book) async {
    try {
      // Convert Entity → Model
      final model = BookModel.fromEntity(book);
      final createdModel = await remoteDataSource.createBook(model);
      return Right(createdModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Book>> updateBook(Book book) async {
    try {
      final model = BookModel.fromEntity(book);
      final updatedModel = await remoteDataSource.updateBook(model);
      return Right(updatedModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> deleteBook(int id) async {
    try {
      await remoteDataSource.deleteBook(id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

**Giải thích:**
- Repository Implementation convert Model ↔ Entity
- Handle exceptions và convert thành Failures
- Domain layer chỉ biết về Entities, không biết về Models

### Kết quả mong đợi
- Tạo được Data layer
- Hiểu về models, data sources, repositories

---

## BÀI TẬP 4: PRESENTATION LAYER (REFACTOR TỪ BÀI 10)

### Mục đích
Refactor Presentation layer từ code của Bài 10. Bloc sẽ dùng UseCase thay vì gọi API Service trực tiếp.

### Yêu cầu

**Bước 1: Refactor Bloc (Từ Bài 10)**

**So sánh với Bài 10:**
- **Bài 10:** `BookBloc` gọi trực tiếp `ApiService.getBooks()`
- **Clean Architecture:** `BookBloc` gọi `GetBooks` UseCase

1. **Di chuyển và Refactor Bloc:**
Di chuyển từ `lib/blocs/book/book_bloc.dart` (Bài 10) → `lib/features/books/presentation/bloc/book_bloc.dart` và refactor:

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/book.dart';
import '../../domain/usecases/get_books.dart';
import '../../domain/usecases/create_book.dart';
import '../../domain/usecases/update_book.dart';
import '../../domain/usecases/delete_book.dart';
import '../../../../core/errors/failures.dart';
import 'package:dartz/dartz.dart';

// Events (Giữ nguyên từ Bài 10)
import 'book_event.dart';

// States (Giữ nguyên từ Bài 10, nhưng dùng Entity thay vì Model)
import 'book_state.dart';

// Bloc (Refactor: Dùng UseCase thay vì ApiService)
class BookBloc extends Bloc<BookEvent, BookState> {
  final GetBooks getBooks;
  final CreateBook createBook;
  final UpdateBook updateBook;
  final DeleteBook deleteBook;
  
  BookBloc({
    required this.getBooks,
    required this.createBook,
    required this.updateBook,
    required this.deleteBook,
  }) : super(const BookInitial()) {
    on<LoadBooksEvent>(_onLoadBooks);
    on<RefreshBooksEvent>(_onRefreshBooks);
    on<CreateBookEvent>(_onCreateBook);
    on<UpdateBookEvent>(_onUpdateBook);
    on<DeleteBookEvent>(_onDeleteBook);
  }
  
  // Refactor: Gọi UseCase thay vì ApiService
  Future<void> _onLoadBooks(
    LoadBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookLoading());
    
    // Thay vì: final books = await ApiService.getBooks();
    final result = await getBooks(); // ← Gọi UseCase
    
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }
  
  Future<void> _onRefreshBooks(
    RefreshBooksEvent event,
    Emitter<BookState> emit,
  ) async {
    final result = await getBooks(); // ← Gọi UseCase
    
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (books) => emit(BookLoaded(books)),
    );
  }
  
  Future<void> _onCreateBook(
    CreateBookEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookCreating());
    
    final result = await createBook(event.book); // ← Gọi UseCase
    
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (createdBook) {
        emit(BookCreated(createdBook));
        // Load lại danh sách
        add(const LoadBooksEvent());
      },
    );
  }
  
  Future<void> _onUpdateBook(
    UpdateBookEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookUpdating());
    
    final result = await updateBook(event.book); // ← Gọi UseCase
    
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (updatedBook) {
        emit(BookUpdated(updatedBook));
        // Load lại danh sách
        add(const LoadBooksEvent());
      },
    );
  }
  
  Future<void> _onDeleteBook(
    DeleteBookEvent event,
    Emitter<BookState> emit,
  ) async {
    emit(const BookDeleting());
    
    final result = await deleteBook(event.bookId); // ← Gọi UseCase
    
    result.fold(
      (failure) => emit(BookError(failure.message)),
      (_) {
        emit(BookDeleted(event.bookId));
        // Load lại danh sách
        add(const LoadBooksEvent());
      },
    );
  }
}
```

**Thay đổi chính:**
- ❌ **Bài 10:** `await ApiService.getBooks()`
- ✅ **Clean Architecture:** `await getBooks()` (UseCase)
- ❌ **Bài 10:** `try-catch` để handle error
- ✅ **Clean Architecture:** `result.fold()` để handle `Either<Failure, T>`

**Bước 2: Di chuyển UI (Từ Bài 10)**

2. **Di chuyển Screens:**
- `lib/screens/book_list_screen.dart` → `lib/features/books/presentation/pages/book_list_page.dart`
- `lib/screens/book_form_screen.dart` → `lib/features/books/presentation/pages/book_form_page.dart`
- `lib/widgets/book_card.dart` → `lib/features/books/presentation/widgets/book_card.dart`

**Cập nhật imports trong các file UI:**
```dart
// Thay vì:
import '../blocs/book/book_bloc.dart';

// Thành:
import '../bloc/book_bloc.dart'; // Path mới
```

**Cập nhật BookListPage để inject UseCases:**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/book_bloc.dart';
import '../bloc/book_event.dart';
import '../bloc/book_state.dart';
import '../../../../injection/injection_container.dart' as di;

class BookListPage extends StatelessWidget {
  const BookListPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<BookBloc>()..add(const LoadBooksEvent()),
      child: const BookListView(),
    );
  }
}
```
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../../../core/errors/failures.dart';

// Events
abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

// States
abstract class ProductState {}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  ProductLoaded(this.products);
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}

// Bloc
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  
  ProductBloc({required this.getProducts}) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }
  
  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    
    final result = await getProducts();
    
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductLoaded(products)),
    );
  }
}
```

2. **Tạo UI:**
Tạo `lib/features/products/presentation/pages/product_list_page.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        getProducts: GetProducts(
          // Inject repository
        ),
      )..add(LoadProducts()),
      child: Scaffold(
        appBar: AppBar(title: Text('Products')),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is ProductLoaded) {
              return ListView.builder(
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price}'),
                  );
                },
              );
            }
            return Center(child: Text('No data'));
          },
        ),
      ),
    );
  }
}
```

### Kết quả mong đợi
- Tạo được Presentation layer
- Hiểu về Bloc pattern trong Clean Architecture

---

## BÀI TẬP 5: DEPENDENCY INJECTION

### Mục đích
Thiết lập Dependency Injection để kết nối các layers. Thay vì tạo object trực tiếp, chúng ta dùng DI container.

### Yêu cầu

1. **Thêm package:**
```yaml
dependencies:
  get_it: ^7.6.4  # Dependency Injection container
  dartz: ^0.10.1  # Either<Failure, T>
```

2. **Tạo injection container:**
Tạo `lib/injection/injection_container.dart`:

**So sánh với Bài 10:**
- **Bài 10:** Tạo object trực tiếp: `BookBloc()..add(LoadBooksEvent())`
- **Clean Architecture:** Inject dependencies qua DI container

```dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import '../features/books/data/datasources/book_remote_data_source.dart';
import '../features/books/data/repositories/book_repository_impl.dart';
import '../features/books/domain/repositories/book_repository.dart';
import '../features/books/domain/usecases/get_books.dart';
import '../features/books/domain/usecases/create_book.dart';
import '../features/books/domain/usecases/update_book.dart';
import '../features/books/domain/usecases/delete_book.dart';
import '../features/books/presentation/bloc/book_bloc.dart';

final sl = GetIt.instance; // Service Locator

Future<void> init() async {
  // ═══════════════════════════════════════
  // Presentation Layer (Bloc)
  // ═══════════════════════════════════════
  sl.registerFactory(
    () => BookBloc(
      getBooks: sl(),
      createBook: sl(),
      updateBook: sl(),
      deleteBook: sl(),
    ),
  );
  
  // ═══════════════════════════════════════
  // Domain Layer (Use Cases)
  // ═══════════════════════════════════════
  sl.registerLazySingleton(() => GetBooks(sl()));
  sl.registerLazySingleton(() => CreateBook(sl()));
  sl.registerLazySingleton(() => UpdateBook(sl()));
  sl.registerLazySingleton(() => DeleteBook(sl()));
  
  // ═══════════════════════════════════════
  // Data Layer (Repository)
  // ═══════════════════════════════════════
  sl.registerLazySingleton<BookRepository>(
    () => BookRepositoryImpl(remoteDataSource: sl()),
  );
  
  // ═══════════════════════════════════════
  // Data Layer (Data Sources)
  // ═══════════════════════════════════════
  sl.registerLazySingleton<BookRemoteDataSource>(
    () => BookRemoteDataSourceImpl(client: sl()),
  );
  
  // ═══════════════════════════════════════
  // External Dependencies
  // ═══════════════════════════════════════
  sl.registerLazySingleton(() => http.Client());
}
```

**Giải thích Dependency Graph:**
```
BookBloc
  ↓ (depends on)
GetBooks, CreateBook, UpdateBook, DeleteBook
  ↓ (depends on)
BookRepository (interface)
  ↓ (implemented by)
BookRepositoryImpl
  ↓ (depends on)
BookRemoteDataSource (interface)
  ↓ (implemented by)
BookRemoteDataSourceImpl
  ↓ (depends on)
http.Client
```

3. **Cập nhật main.dart:**
```dart
import 'package:flutter/material.dart';
import 'injection/injection_container.dart' as di;
import 'features/books/presentation/pages/book_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Dependency Injection
  await di.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Management',
      home: const BookListPage(),
    );
  }
}
```

**So sánh với Bài 10:**
- **Bài 10:** `BlocProvider(create: (_) => BookBloc()..add(...))`
- **Clean Architecture:** `BlocProvider(create: (_) => di.sl<BookBloc>()..add(...))`

---

### Kết quả mong đợi
- Thiết lập được Dependency Injection
- Kết nối được các layers

---

## 📊 SO SÁNH TRƯỚC VÀ SAU REFACTOR

### Cấu trúc Bài 10 (Feature-based)

**Ưu điểm:**
- ✅ Đơn giản, dễ hiểu
- ✅ Ít code hơn
- ✅ Phù hợp app nhỏ/trung bình
- ✅ Làm nhanh, ra sản phẩm nhanh

**Nhược điểm:**
- ⚠️ Logic nghiệp vụ lẫn với UI
- ⚠️ Khó test logic độc lập
- ⚠️ Khó thay đổi data source
- ⚠️ Code dễ rối khi app lớn

### Cấu trúc Clean Architecture (Sau refactor)

**Ưu điểm:**
- ✅ Tách biệt rõ ràng các layers
- ✅ Dễ test từng layer độc lập
- ✅ Dễ thay đổi (API → Local DB)
- ✅ Scalable, chuyên nghiệp

**Nhược điểm:**
- ⚠️ Nhiều code hơn (nhiều files)
- ⚠️ Phức tạp hơn cho người mới
- ⚠️ Overkill cho app nhỏ

### Quyết định: Khi nào dùng gì?

```
App nhỏ (< 3 features, < 10 màn hình)
    ↓
Dùng cấu trúc Bài 10 (Feature-based)
    ↓
App lớn (> 5 features, nhiều màn hình)
    ↓
Refactor lên Clean Architecture
```

---

## 🔄 WORKFLOW REFACTOR TỪ BÀI 10

### Bước 1: Chuẩn bị
```bash
# Backup code Bài 10
cp -r book_management_app book_management_app_backup

# Tạo branch mới (nếu dùng Git)
git checkout -b clean-architecture-refactor
```

### Bước 2: Tạo cấu trúc mới
```
1. Tạo thư mục core/
2. Tạo thư mục features/books/
3. Tạo các thư mục con: data, domain, presentation
```

### Bước 3: Di chuyển và Refactor
```
1. Model → Entity + Model (tách riêng)
2. ApiService → DataSource (refactor)
3. Thêm Repository Interface + Implementation
4. Thêm UseCases
5. Refactor Bloc (dùng UseCase)
6. Di chuyển UI (screens, widgets)
```

### Bước 4: Dependency Injection
```
1. Cài get_it package
2. Tạo injection_container.dart
3. Đăng ký tất cả dependencies
4. Cập nhật main.dart
```

### Bước 5: Test và Fix
```
1. Chạy app và test các tính năng
2. Fix lỗi imports
3. Fix lỗi dependency injection
4. Verify app hoạt động giống như Bài 10
```

---

## 📝 CHECKLIST HOÀN THÀNH

Sau khi hoàn thành tất cả bài tập, bạn nên:
- [ ] Hiểu nguyên tắc Clean Architecture
- [ ] So sánh được cấu trúc Bài 10 vs Clean Architecture
- [ ] Refactor được dự án từ Bài 10 lên Clean Architecture
- [ ] Tổ chức code theo layers (Presentation, Domain, Data)
- [ ] Tách biệt business logic và UI
- [ ] Sử dụng Dependency Injection
- [ ] Xây dựng được ứng dụng theo chuẩn Clean Architecture

---

## 🎯 BÀI TẬP MỞ RỘNG

1. **Thêm Local Data Source:**
   - Tạo `BookLocalDataSource` (SQLite/SharedPreferences)
   - Update Repository để dùng Local khi offline
   - Test offline mode

2. **Thêm Cache:**
   - Cache dữ liệu từ API
   - Hiển thị cache trước, sau đó fetch mới
   - Implement cache invalidation

3. **Viết Tests:**
   - Unit test cho UseCases
   - Unit test cho Repository
   - Unit test cho DataSource
   - Bloc test cho BookBloc

4. **Thêm feature mới:**
   - Tạo feature "Categories" theo Clean Architecture
   - Verify không ảnh hưởng feature Books
   - Test tương tác giữa 2 features

5. **So sánh Performance:**
   - So sánh app performance trước và sau refactor
   - Measure build time, runtime performance

---

## 📚 TÀI LIỆU THAM KHẢO

- [Clean Architecture - Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Reso Coder - Flutter Clean Architecture](https://resocoder.com/flutter-clean-architecture-tdd/)
- [GetIt Package](https://pub.dev/packages/get_it)
- [Dartz Package](https://pub.dev/packages/dartz)
- [Bài 10b - Dự án Tổng hợp: Bloc + Provider + .NET API](../10b_thuc_hanh_du_an_tong_hop_bloc_provider_api.md) - Dự án gốc để refactor

---

## 🎉 KẾT THÚC

Chúc mừng! Bạn đã hoàn thành bài thực hành Clean Architecture và refactor dự án từ Bài 10.

**Bạn đã học được:**
- ✅ So sánh Feature-based vs Clean Architecture
- ✅ Refactor dự án thực tế
- ✅ Tổ chức code theo layers
- ✅ Dependency Injection
- ✅ Tách biệt Domain, Data, Presentation

👉 **Tiếp theo:** Bài 15 - Testing để test các UseCases và Repository
