//
//  HistoryPresensiRangePegawaiViewModel.swift
//  AbsensiKepegawaian
//
//  Created by Mirliyawan Ibrahim on 15/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON

class HistoryPresensiRangePegawaiViewModel: ObservableObject {
    
    @Published var successRequest: (() -> ())?
    @Published var failureRequest: (() -> ())?
    @Published public var message: String?
    @Published public var dataHistoryPresensiRangeModel: [HistoryPresensiRangeModel]? = []
    @Published public var dataGroup: [String: [HistoryPresensiRangeModel?]] = [:]

    private let refreshToken = UserDefaults.standard.getLoginRefreshToken()
    
    public func getHistoryPresensiPegawai() {
        
        HistoryPresensiRangePegawaiService.shareInstance.getHistoryPresensiRangePegawai { [weak self] (result, message, data, code) in
            switch result {
            case .success(_):
                self?.dataHistoryPresensiRangeModel = data ?? nil
                self?.dataGroup = Dictionary(grouping: data!, by: { $0.timestampAbsensi! })
                self?.message = message
                self?.successRequest?()
                break
            case .failure(_):
                if code == 401 {
                    RefreshTokenService.shareInstance.parameterRefreshToken = ["token": self?.refreshToken ?? ""]
                    RefreshTokenService.shareInstance.postRefreshToken { [weak self] (result_, message_, data, code_) in
                        switch result_ {
                        case .success(_):
                            if code_ == 200 {
                                UserDefaults.standard.setLoginUserToken(value: (data?.accessToken)!)
                                UserDefaults.standard.setLoginRefreshToken(value: (data?.refreshToken)!)
                                UserDefaults.standard.setIsLogin(value: true)
                                self?.getHistoryPresensiPegawai()
                            }else {
                                self?.message = message_
                                UserDefaults.standard.setIsLogin(value: false)
                                self?.failureRequest?()
                            }
                        case .failure:
                            if code_ == 401 {
                                self?.message = "logout"
                                UserDefaults.standard.setIsLogin(value: false)
                                self?.failureRequest?()
                            } else {
                                self?.message = message_
                                UserDefaults.standard.setIsLogin(value: false)
                                self?.failureRequest?()
                            }
                        }
                    }
                }
            }
        }
    }
}

