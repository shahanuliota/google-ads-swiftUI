//
//  response.model.swift
//  google_ads_check
//
//  Created by Shahanul on 16/7/23.
//

import Foundation

struct AppResponse<T> {
    let statusCode: Int
    let payload: T?

    var success: Bool {
        return 200...299 ~= statusCode
    }

    init(statusCode: Int, payload: T?) {
        self.statusCode = statusCode
        self.payload = payload
    }
}

