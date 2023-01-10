//
//  GetActiveWeatherReportsRepository.swift
//  weather_app
//
//  Created by Petru-Alexandru Lipici on 06.01.2023.
//

import Foundation

class GetActiveWeatherReportsRepository: RemoteRepository<GetActiveWeatherReportsModel> {
    
    required init() {
        let endpoint = RemoteRepositoryDataLoaderRequestEndpoint(
            endpoint: Paths.GET_ACTIVE_ALERTS,
            httpMethod: .get
        )
        let dataLoader = CommonRepositoryDataLoader(requestEndpoint: endpoint)
        
        super.init(request: dataLoader)
    }
}

