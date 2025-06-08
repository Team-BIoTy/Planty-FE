# 🌱 Planty Frontend

### 📁 프로젝트 구조

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

