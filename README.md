# 2023 대구를 빛내는 해커톤 [최우수상 수상]
### 👩‍👦‍👦 팀명 
- 연탄급식소
  
### ✍ 제출 타입 및 주제 
- S타입. 권리 보호를 위한 SW 개발
  
###  📝 프로젝트 한 줄 설명
- 소외계층들을 위한 무료급식소의 위치를 한눈에 볼 수 있는 앱 개발
  
### 📚 프로젝트에 활용된 기술 
- 프레임워크 : Flutter 사용
  - 안드로이드와 ios 앱 개발을 위해 flutter 사용
  - 개발환경으로 vscode 및 android studio 사용
    <br/> <br/> 
    [vscode]
    <br/> <br/> 
    <img src = "https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/aeab201c-34c5-46a2-87c3-5715e129e32a">
    <br/> <br/> 
    [Android Studio]
    <br/> <br/> 
    <img src = "https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/260a6dad-1e67-45ee-ad1d-0e089f247cff">
    <br/> <br/> 
  - 개발 언어는 dart 사용  
<br/> <br/> 
- Database : firebase 사용   
  - flutter와 DB를 연동하기 위해 firebase 사용
<br/> <br/> 
     <img src = "https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/4e27f08b-2d37-45a6-938c-62c10358711f">
<br/> <br/> 
  - 공공데이터포털의 "전국무료급식소표준데이터"를 DB에 저장 및 가공하여 사용
<br/> <br/> 
    <img src = "https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/06b2e84e-ff18-4537-8ee7-d3caf21337b0">
<br/> <br/> 
  - 쿼리문을 사용하여 firebase의 코드 불러옴
<br/> <br/>
[모든 데이터 불러오기 및 요일별/대상별/식사시간방법 으로 데이터 찾기]
<br/> <br/>
  ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/e34affde-782c-4143-904a-d65f4e08d03f)
<br/> <br/>
  ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/8328d03c-f871-4213-89c8-795109c30111)
<br/> <br/>
  ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/12a1c97d-21bb-4ae0-b907-9a5537a6d431)
<br/> <br/>
  - firebase를 통한 구글 로그인 구현
  <br/> <br/>
    [구글 로그인을 통해 firebase에 저장된 사용자 정보]
  <br/> <br/>
    ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/93db68b5-256a-4049-bf1b-fc8605a13430)
  <br/> <br/>
  [구글 로그인 코드 -  pages/settings.dart]
<br/> <br/>
  ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/68fc97a6-19af-4b6f-9667-25d696ae5abd)
  ![image](https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/283a27f8-424b-42a9-977b-35422d648e14)
<br/> <br/>

- 지도를 구현하기 위해 Google Map API 및 Google Places API 를 활용
<br/> <br/>
[Google Map API]
<br/> <br/> 
    <img src = "https://github.com/beoldshoe/2023_hackathon_biquet-cafeteria/assets/107935469/dafc8d5e-a75d-4b8c-ad10-0542828a2cde">
<br/> <br/>

  - 지도 불러오기
  - google map 자동완성검색창 구현 및 검색한 위치로 지도 중심 이동
  - GPS기능 구현으로 현재 위치로 이동 가능
  - data셋에 입력된 데이터들을 마커로 지도에 표시
    
### 📽 시연 영상
- 유튜브 링크 : https://youtu.be/3pgdMx8DGkc
<br/> <br/> 
  [유튜브에 걸어놓은 타임 스탬프 정리]
<br/> <br/>
  2023 대구를 빛내는 해커톤 - 10팀 연탄급식소  
  연탄급식소 실행 동영상입니다.  
  <br/>
  - 00:00 [앱 다운]
  - 00:02 [앱 실행]
  - 00:11 [위치 정보 동의]
  - 00:20 [무료급식소 전국 위치]
  - 00:27 [검색창 대구 입력 - 자동 완성된 주소 중 대구삼성라이온즈파크 선택]
  - 00:34 [대구삼성라이온즈로 지도 중심 이동]
  - 00:43 [ GPS 버튼으로 현재 위치로 돌아옴]
  - 00:46 [ 요일별 전국 무료 급식소 데이터 보여줌]
  - 01:08 [ 대상별 전국 무료 급식소 데이터 보여줌 (저소득층 - 노숙인 - 대상전체)]
  - 01:21 [식사 시간/방법 별 무료 급식소 데이터 보여줌 (중식-배달-식사 시간/ 방법)]
  - 01:46 [지도 줌 기능]
  - 01:56 [마커 누르면 장소에 대한 정보 제공]
  - 02:13 [지역별 급식소 목록으로 이동 (기본 - 서울)]
  - 02:21 [지역별 급식소 목록으로 이동 (대구 선택)]
  - 02:26 [지역별 급식소 목록으로 이동 (제주도 선택)]
  - 02:34 [설정 페이지로 이동]
  - 02:36 [구글 계정 로그인]
  - 02:42 [로그아웃 기능]
