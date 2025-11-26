import Foundation

class GalaxyStore: ObservableObject {
    @Published var galaxies: [Galaxy] = [] // UI에 보여줄 은하 목록
    
    let projectURL = "https://rivjpilpvmxiypbqgxdx.supabase.co"
    let apiKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJpdmpwaWxwdm14aXlwYnFneGR4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NDcwOTksImV4cCI6MjA3NzEyMzA5OX0.Kzi0o9MZUB_mjbJcboaon7jj5srjHE_c7yDrNjhXcPM"
    
    func fetchGalaxies() {
        // 1. URL 생성 (테이블 이름: galaxies, 모든 컬럼 선택: select=*)
        guard let url = URL(string: "\(projectURL)/rest/v1/galaxies?select=*") else { return }
        
        // 2. 요청(Request) 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Supabase 인증 헤더 추가 (필수)
        request.addValue(apiKey, forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        // 3. URLSession으로 통신 시작 (과제 필수 요건)
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러 체크
            if let error = error {
                print("에러 발생: \(error.localizedDescription)")
                return
            }
            
            // 데이터 파싱
            if let data = data {
                do {
                    // JSON 데이터를 Galaxy 배열로 변환
                    let decodedData = try JSONDecoder().decode([Galaxy].decode, from: data)
                    
                    // UI 업데이트는 반드시 메인 스레드에서
                    DispatchQueue.main.async {
                        self.galaxies = decodedData
                        // 날짜순(id순) 정렬이 필요하면 여기서 .sorted() 사용
                    }
                } catch {
                    print("데이터 변환 실패: \(error)")
                }
            }
        }.resume() // 통신 시작 명령
    }
}
