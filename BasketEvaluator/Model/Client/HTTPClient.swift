//
//  HTTPClient.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 28/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

typealias CompletionHandlerForGET = (Data?, Error?) -> Void
typealias CompletionHandlerForURLSession = (Data?, URLResponse?, Error?) -> Void

// MARK: - URLSessionProtocol

protocol URLSessionProtocol {
    /// allows to get a task that retreives the content at the specified URL
    func dataTask(with url: URL, completionHandler: @escaping CompletionHandlerForURLSession) -> URLSessionDataTaskProtocol
}

// MARK: - URLSessionDataTaskProtocol

protocol URLSessionDataTaskProtocol {
    /// starts/resumes the execution of the data task
    func resume()
}

// MARK: - URLSession 

extension URLSession: URLSessionProtocol {
    /// allows to get a task that retreives the content at the specified URL
    func dataTask(with url: URL, completionHandler: @escaping CompletionHandlerForURLSession) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

// MARK: - URLSessionDataTask

extension URLSessionDataTask: URLSessionDataTaskProtocol { } // already conforms to protocol

// MARK: - HTTPClient

/// The HTTPClient allows to read data via a simple GET request and returns the result via a completion handler.
class HTTPClient {
    
    // MARK: - Properties
    
    // the URLSession required for network fetching purposes
    let urlSession: URLSessionProtocol!
    
    init(urlSession: URLSessionProtocol) {
        self.urlSession = urlSession
    }
    
    // MARK: GET
    
    /// The taskForGETMethod method allows to read data via a simple GET request and returns the result via a completion handler.
    func taskForGETMethod(method: String,
                          parameters: [String:AnyObject],
                          completionHandler: @escaping CompletionHandlerForGET) -> URLSessionDataTaskProtocol {
        
        // assemble the url
        let url = URLFrom(parameters: parameters, withPathExtension: method)
        
        // make the request
        let task = urlSession.dataTask(with: url) { (data, response, error) in
            
            func sendError(withMessage message: String) {
                let userInfo = [NSLocalizedDescriptionKey : message]
                completionHandler(nil, NSError(domain: HTTPConstants.TaskForGETMethod, code: 1, userInfo: userInfo))
            }
            
            // was there an error?
            guard(error == nil) else {
                sendError(withMessage: "\(error!.localizedDescription)")
                return
            }
            
            // did we get a successful 2XX response?
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(withMessage: HTTPConstants.InvalidStatusCode)
                return
            }
            
            // was there any data returned?
            guard let data = data else {
                sendError(withMessage: HTTPConstants.EmptyData)
                return
            }
            
            completionHandler(data, nil)
            
        }
        
        // start the request
        task.resume()
        return task
    }
    
    // MARK: Utility
    
    private func URLFrom(parameters: [String:AnyObject], withPathExtension pathExtension : String? = nil) -> URL {
        
        // generates the url components
        var components = getURLComponents(withPathExtension: pathExtension)
        
        if parameters.isEmpty {
            return components.url!
        }
        
        components.queryItems = [URLQueryItem]()
        
        // adds the parameters (i.e. ?count=10&x=3)
        for(key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        // returns the components as url
        return components.url!
        
    }
    
    func getURLComponents(withPathExtension pathExtension: String? = nil) -> URLComponents {
        var components = URLComponents()
        // puts http as the component's scheme
        components.scheme = HTTPConstants.APIScheme
        return components
    }
    
    // MARK: - Helpers
    
    func convertDataToJSON(data: Data) -> AnyObject? {
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    }
    
    func convertJSONToData(json: AnyObject) -> Data? {
        return try? JSONSerialization.data(withJSONObject: json, options: [])
    }
    
}
