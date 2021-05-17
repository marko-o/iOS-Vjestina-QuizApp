//
//  NetworkServiceProtocol.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation

protocol NetworkServiceProtocol {
    
    func executeLoginRequest(_ request: URLRequest, bodyData: Data, completionHandler: @escaping (LoginCredentials?, RequestError?) -> Void)
    
    func executeGetQuizzesRequest(_ request: URLRequest, completionHandler: @escaping ([Quiz]?, RequestError?) -> Void)
    
    func executeQuizResultsUploadRequest(_ request: URLRequest, bodyData: Data, completionHandler: @escaping (QuizResultsUploadResponse?, RequestError?) -> Void)
}
