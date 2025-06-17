<img alt="flutter" src="https://img.shields.io/badge/flutter-02569B.svg?style=for-the-badge&logo=flutter&logoColor=white" height="20"/> <img alt="dart" src="https://img.shields.io/badge/dart-0175C2.svg?style=for-the-badge&logo=dart&logoColor=white" height="20"/> <img alt="firebase" src="https://img.shields.io/badge/firebase-DD2C00.svg?style=for-the-badge&logo=firebase&logoColor=white" height="20"/> <img alt="android" src="https://img.shields.io/badge/android-3DDC84.svg?style=for-the-badge&logo=android&logoColor=white" height="20"/>

# 🌱 Planty Frontend

**Planty Project**에서 사용하는 Flutter 기반 프론트엔드 레포지토리입니다.<br>
식물 정보 조회, 센서 데이터 수신 및 IoT 제어, 챗봇 연동, 푸시알림 등 다양한 기능을 제공합니다.

### 프로젝트 개요
- **전체 개발 기간**: 2025.03.12 - 2025.06.11
   - UI/UX 설계: 2025.03.12 - 2025.03.26
   - 기능 개발: 2025.04.14 - 2025.06.11
      - 4월: 회원가입/로그인, 홈 화면, 식물 등록
      - 5월: 식물 상세 리포트, 챗봇, UI/UX 개선
      - 6월: FCM 푸시 알림, 마이페이지

</br>

## 📌 사전 준비 (Flutter 환경 세팅)

이 프로젝트는 Flutter 개발 환경과 Android 에뮬레이터 설정이 필요합니다.</br>
사용자의 기기에 맞는 가이드를 따라 진행해주세요.

- [MacOS - Flutter 설치 가이드](https://docs.flutter.dev/get-started/install/macos/mobile-android) </br>
- [Windows - Flutter 설치 가이드](https://docs.flutter.dev/get-started/install/windows/mobile)

</br>

## 📦 설치 및 실행

### 1. 레포지토리 클론
```bash
git clone https://github.com/Team-BIoTy/Planty-FE.git
cd Planty-FE
```

### 2. Flutter 의존성 설치
```bash
flutter pub get
```

</br>

## ⚙️ 환경 설정

### 1. `.env` 설정
API 서버 주소 설정을 위해 .env 파일을 아래 경로에 추가해주세요.

```
BASE_URL='http://10.0.2.2:8080'
````
- Android: `Planty-FE/planty/.env`


### 2. Firebase 설정
FCM 푸시 알림을 수신하기 위해 Firebase 설정 파일을 추가해야 합니다.
[Firebase 콘솔](https://firebase.google.com/)에서 프로젝트를 생성하고 앱을 등록한 후 google-services.json 파일을 발급받아 아래 경로에 추가해주세요.

- Android: `Planty-FE/planty/android/app/google-services.json`

</br>

## 🔗 외부 시스템 선행 실행

해당 프론트엔드 앱은 아래 서버들과 연동되어 동작합니다.<br>
각 레포지토리의 Readme를 참고해 초기 설정 및 실행을 완료해주세요.

| 시스템       | 설명                           | 레포 링크 |
|--------------|--------------------------------|-----------|
| Spring Boot  | 백엔드 API | [Planty Backend](https://github.com/Team-BIoTy/Planty-BE) |
| Agent Server (FastAPI) | 식물 챗봇 응답 생성용 LLM 서버 | [Planty Agent](https://github.com/Team-BIoTy/Planty_Agent) |


</br>

## 🚀 앱 실행
Android 에뮬레이터 또는 실기기에서 앱을 실행할 수 있습니다.

```
flutter run
```
> 실행 전 Android 에뮬레이터 또는 디바이스가 연결되어 있는지 확인해주세요.

</br>

## 📁 프로젝트 구조

```
planty
├── lib/                             # 애플리케이션 핵심 로직
│   ├── constants/                   # 상수 정의 (색상)
│   ├── models/                      # 서버 응답을 위한 데이터 모델 클래스
│   ├── screens/                     # 화면 UI 구성
│   ├── services/                    # API 통신 및 비즈니스 로직 처리
│   └── widgets/                     # 커스텀 위젯 컴포넌트
│
├── assets/                          # 정적 리소스 파일
│   ├── fonts/                       # 커스텀 폰트 파일
│   └── images/                      # 이미지 파일 (로고, 기본 이미지 등)
│
├── android/                         # Android 플랫폼 설정
│   ├── app/
│   │   ├── build.gradle.kts         # 앱 수준 Gradle 설정
│   │   ├── google-services.json     # Firebase 연동 설정 파일
│   │   └── src/                     # 플랫폼 네이티브 코드
│   ├── build.gradle.kts             # 프로젝트 수준 Gradle 설정
│   └── settings.gradle.kts          # 모듈 포함 설정
│
├── ios/                             # iOS 플랫폼 설정
├── macos/                           # macOS 플랫폼 설정
├── linux/                           # Linux 앱 설정
├── windows/                         # Windows 앱 설정
├── web/                             # Flutter Web 설정

├── pubspec.yaml                     # Flutter 패키지 및 리소스 정의 파일
├── pubspec.lock                     # 의존성 버전 고정 파일
├── analysis_options.yaml            # Dart 정적 분석 설정
```

