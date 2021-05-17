//
//  NetworkService.swift
//  QuizApp
//
//  Created by five on 15/05/2021.
//  Copyright © 2021 five. All rights reserved.
//

import Foundation

class NetworkService: NetworkServiceProtocol {
    
    func executeLoginRequest(_ request: URLRequest, bodyData: Data, completionHandler: @escaping (LoginCredentials?, RequestError?) -> Void) {
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
    
    func executeGetQuizzesRequest(_ request: URLRequest, completionHandler: @escaping ([Quiz]?, RequestError?) -> Void) {
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
    
    func executeQuizResultsUploadRequest(_ request: URLRequest, bodyData: Data, completionHandler: @escaping (QuizResultsUploadResponse?, RequestError?) -> Void) {
        let task = URLSession.shared.uploadTask(with: request, from: bodyData) {
            data, response, err in
            guard err == nil else {
                DispatchQueue.main.async {
                    completionHandler(nil, .clientError)
                }
                return
            }
            
            //var serverResponse: ServerResponse
            
            //            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            //                else {
            //                    DispatchQueue.main.async {
            //                        completionHandler(.ok, .serverError)
            //
            //                    }
            //                    return
            //
            //            }
            
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
                    case _:
                        serverResponse = nil
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
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completionHandler(nil, .noDataError)
                }
                return
            }
            
            guard let value = try? JSONDecoder().decode(QuizResultsUploadResponse.self, from: data) else {
                DispatchQueue.main.async {
                    completionHandler(nil, .decodingError)
                }
                return
                
            }
            
            DispatchQueue.main.async {
                completionHandler(value, nil)
            }
            
            
        }
        task.resume()
    }
    
//    func executeURLRequest(_ request: URLRequest, completionHandler: @escaping (String?, RequestError?) -> Void) {
//        let dataTask = URLSession.shared.dataTask(with: request) {
//            data, response, err in
//            guard err != nil else {
//                DispatchQueue.main.async {
//                    completionHandler(nil, .clientError)
//                }
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
//                else {
//                    DispatchQueue.main.async {
//                        completionHandler(nil, .serverError)
//
//                    }
//                    return
//
//            }
//            guard let data = data else {
//                DispatchQueue.main.async {
//                    completionHandler(nil, .noDataError)
//                }
//                return
//
//            }
//
//            guard let value = try?JSONDecoder().decode(ServerResponse.self,from: data) else {
//                DispatchQueue.main.async {
//                    completionHandler(nil, .decodingError)
//                }
//                return
//
//            }
//            
//            DispatchQueue.main.async {
//                completionHandler(value, nil)
//            }
//        }
//
//        dataTask.resume()
//    }
    
}
