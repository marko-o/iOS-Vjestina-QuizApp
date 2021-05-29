//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func executeLoginRequest(bodyData: Data, completionHandler: @escaping (LoginCredentials?, RequestError?) -> Void)
    
    func executeGetQuizzesRequest(completionHandler: @escaping ([Quiz]?, RequestError?) -> Void)
    
    func executeQuizResultsUploadRequest(token: String, bodyData: Data, completionHandler: @escaping (QuizResultsUploadResponse?, RequestError?) -> Void)
}
