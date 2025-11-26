import SwiftUI

struct ContentView: View {
    // 통신 매니저 연결
    @StateObject var store = GalaxyStore()
    
    var body: some View {
        // 1. TabView 사용 (과제 필수)
        TabView {
            // 첫 번째 탭: 은하 리스트
            NavigationStack {
                List(store.galaxies) { galaxy in
                    // 리스트 아이템 클릭 시 이동할 링크
                    NavigationLink(destination: GalaxyDetailView(galaxy: galaxy)) {
                        HStack {
                            // 썸네일 이미지 (작게)
                            if let urlStr = galaxy.imageUrl, let url = URL(string: urlStr) {
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            VStack(alignment: .leading) {
                                Text(galaxy.name)
                                    .font(.headline)
                                Text(galaxy.type)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("은하 목록") // 네비게이션 타이틀 (과제 필수)
                .onAppear {
                    // 화면이 나타날 때 데이터 불러오기
                    store.fetchGalaxies()
                }
            }
            .tabItem {
                Image(systemName: "star.fill")
                Text("은하")
            }
            
            // 두 번째 탭 (TabView 구색 맞추기용)
            Text("정보 탭입니다.")
                .tabItem {
                    Image(systemName: "info.circle")
                    Text("정보")
                }
        }
    }
}

// 세부 화면 (Detail View)
struct GalaxyDetailView: View {
    let galaxy: Galaxy
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 큰 이미지
                if let urlStr = galaxy.imageUrl, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView() // 로딩 중 뺑뺑이
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                }
                
                // 제목과 유형
                VStack(alignment: .leading) {
                    Text(galaxy.name)
                        .font(.largeTitle)
                        .bold()
                    Text(galaxy.type)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Divider() // 구분선
                
                // 상세 정보 그리드
                GridInfoView(title: "거리", value: galaxy.distance)
                
                if let size = galaxy.size {
                    GridInfoView(title: "지름", value: size)
                }
                
                if let mass = galaxy.mass {
                    GridInfoView(title: "질량", value: mass)
                }
                
                Divider()
                
                // 설명
                Text("설명")
                    .font(.headline)
                
                Text(galaxy.description ?? "설명 없음")
                    .font(.body)
                    .lineSpacing(5)
            }
            .padding()
        }
        .navigationTitle(galaxy.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// 정보를 예쁘게 보여주기 위한 작은 뷰
struct GridInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .font(.body)
        }
    }
}

#Preview {
    ContentView()
}
