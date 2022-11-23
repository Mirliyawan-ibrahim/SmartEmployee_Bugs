//
//  HistoryPresensiRangeModel.swift
//  AbsensiKepegawaian
//
//  Created by Mirliyawan Ibrahim on 15/11/22.
//

import Foundation

// MARK: - History Presensi Range Model
struct HistoryPresensiRangeModel: Hashable, Codable {
    let timestampAbsensi, tipeAbsensi,labelAbsensi,timeLimitDatang,timeLimitPulang,catatanAbsensi: String?

    enum HistoryPresensiRangeKeys: String, CodingKey {
        case timestampAbsensi = "timestamp_absensi"
        case tipeAbsensi = "tipe_absensi"
        case labelAbsensi = "label_absensi"
        case timeLimitDatang = "time_limit_datang"
        case timeLimitPulang = "time_limit_pulang"
        case catatanAbsensi = "catatan_absensi"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: HistoryPresensiRangeKeys.self)
        timestampAbsensi = try values.decodeIfPresent(String.self, forKey: .timestampAbsensi) ?? ""
        tipeAbsensi = try values.decodeIfPresent(String.self, forKey: .tipeAbsensi) ?? ""
        labelAbsensi = try values.decodeIfPresent(String.self, forKey: .labelAbsensi) ?? ""
        timeLimitDatang = try values.decodeIfPresent(String.self, forKey: .timeLimitDatang) ?? ""
        timeLimitPulang = try values.decodeIfPresent(String.self, forKey: .timeLimitPulang) ?? ""
        catatanAbsensi = try values.decodeIfPresent(String.self, forKey: .catatanAbsensi) ?? ""
    }
}

