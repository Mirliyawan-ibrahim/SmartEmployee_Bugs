//
//  HistoryPresensiRangePegawaiService.swift
//  AbsensiKepegawaian
//
//  Created by Mirliyawan Ibrahim on 15/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class HistoryPresensiRangePegawaiService: NSObject {
    
    static let shareInstance = HistoryPresensiRangePegawaiService()
    
    //MARK: SERVICE GET HISTORY PRESENSI PEGAWAI SERVICE
    public func getHistoryPresensiRangePegawai(completion: @escaping(Result<Bool, ErrorsApi>, String?, [HistoryPresensiRangeModel]?, Int?) -> ()) {
        
        // MARK: UserDefault
        let loginUserToken = UserDefaults.standard.getLoginUserToken()
        
        // MARK: Headers
        let headers : HTTPHeaders = ["Authorization": "Bearer \(loginUserToken)","Content-Type":"application/json"]

        AF.request(AbsenAPI.URL_HISTORY_PRESENSI_RANGE,
                   method: .get,
                   parameters: nil,
                   encoding: JSONEncoding.default, headers: headers).responseData { response in
            
            switch response.result {
            case .success:
                let json = JSON(response.value as Any)
                if response.response?.statusCode == 200 {
                    if let data = response.data {
                        let decoder = JSONDecoder()
                        do {
                            let datadecoder = try decoder.decode([HistoryPresensiRangeModel].self, from: data)
                            completion(.success(true), "", datadecoder, response.response?.statusCode)
                        } catch {
                            var message: String?
                            if let message_ = json["errors"]["msg"].string {
                                message = message_
                            } else {
                                message = "Mohon maaf data tidak ditemukan"
                            }
                            completion(.failure(ErrorsApi.errorData), message, nil, response.response?.statusCode)
                        }
                    }
                } else {
                    let json = JSON(response.value as Any)
                    var message: String?
                    if let message_ = json["errors"]["msg"].string {
                        message = message_
                    } else if let message_ = json["errors"].string {
                            message = message_
                    } else {
                        message = "Mohon maaf data tidak ditemukan"
                    }
                    completion(.failure(ErrorsApi.errorData), message, nil, response.response?.statusCode)
                }
            case .failure:
                let json = JSON(response.value as Any)
                var message: String?
                if let message_ = json["errors"]["msg"].string {
                    message = message_
                }else{
                    message = "Maaf Terjadi Kesalahan, Cobalah beberapa saat lagi "
                }
                completion(.failure(ErrorsApi.errorServer), message, nil, response.response?.statusCode)
            }
        }
    }
}
