//
//  dtoManagetr.swift
//  Stiint
//
//  Created by Liam Wittig on 26.01.26.
//

import Foundation

@Observable
public class DtoManager{
    
    private(set) var activityDTO: ActivityDTO?
    
    public func setActivityDTO(_ dto: ActivityDTO?){
        self.activityDTO = dto
    }
    
    public func clear(){
        activityDTO = nil
    }
    
}

public extension DtoManager {
    static let shared = DtoManager()
}
