//
//  NetworkService.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func executeLoginRequest(bodyData: Data, completionHandler: @escaping (LoginCredentials?, RequestError?) -> Void) {
        let url = URL(string: "https://iosquiz.herokuapp.com/api/session")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: bodyData) {
            data, response, err in
            guard err == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .clientError)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil, .serverError)
                        
                    }
                    return
                    
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, .noDataError)
                }
                return
                
            }
            
            guard let value = try? JSONDecoder().decode(LoginCredentials.self, from: data) else {
                DispatchQueue.main.async {
                    completionHandler(nil, .decodingError)
                }
                return
                
            }
            // 4.
            DispatchQueue.main.async {
                completionHandler(value, nil)
            }
        }
        
        task.resume()
    }
    
    func executeGetQuizzesRequest(completionHandler: @escaping ([Quiz]?, RequestError?) -> Void) {
        let url = URL(string: "https://iosquiz.herokuapp.com/api/quizzes")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) {
            data, response, err in
            guard err == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .clientError)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                else {
                    DispatchQueue.main.async {
                        completionHandler(nil, .serverError)
                    }
                    return
                    
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, .noDataError)
                }
                return
            }
            
            guard let value = try? JSONDecoder().decode(QuizzesResult.self, from: data) else {
                DispatchQueue.main.async {
                    completionHandler(nil, .decodingError)
                }
                return
            }
            
            let quizzes = value.quizzes
            
            DispatchQueue.main.async {
                completionHandler(quizzes, nil)
            }
        }
        
        task.resume()
    }
    
    func executeQuizResultsUploadRequest(token: String, bodyData: Data, completionHandler: @escaping (QuizResultsUploadResponse?, RequestError?) -> Void) {
        let url = URL(string: "https://iosquiz.herokuapp.com/api/result")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: bodyData) {
            data, response, err in
            guard err == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .clientError)
                }
                return
            }
            
            let httpResponse = response as? HTTPURLResponse
            if httpResponse != nil {
                var serverResponse: ServerResponse?
                var requestError: RequestError?
                if (200...299).contains(httpResponse!.statusCode) {
                    serverResponse = .ok
                    requestError = nil
                } else {
                    requestError = .serverError
                    switch(httpResponse!.statusCode) {
                    case 400:
                        serverResponse = .badRequest
                    case 401:
                        serverResponse = .unauthorized
                    case 403:
                        serverResponse = .forbidden
                    case 404:
                        serverResponse = .notFound
                    default:
                        serverResponse = .unknownResponse(statusCode: httpResponse!.statusCode)
                    }
                }
                let res = QuizResultsUploadResponse(response: serverResponse)
                DispatchQueue.main.async {
                    completionHandler(res, requestError)
                }
            } else {
                DispatchQueue.main.async {
                    completionHandler(nil, .serverError)
                }
            }
            
            guard data != nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .noDataError)
                }
                return
            }
            
        }
        task.resume()
    }
    
}
