//
//  CellTypes.swift
//  BarelTest
//
//  Created by Mikhailo Dovhyi on 10.02.2022.
//

import UIKit


struct CellType {
    struct BlockCollection {
        var itemsInRow:Int?
        var collectionData:[BlockType]
        var selectedDataIndex:Int? = nil
        
        struct BlockType {
            let isGreen:Bool?
            let title:String
        }
    }

    struct Photos {
        let type:PhotoTypeEnum
        var selectedIndex:Int?
        let photos:[PhotoType]
        
        enum PhotoTypeEnum {
            case servicePhotos
            case multiplePhotos//no header
        }
        
        struct PhotoType {
            let photo:UIImage?
            let petName:String//or date if threePhotos == true
            let defaultText:defaultType?
            
            enum defaultType:String {
                case before = "before"
                case during = "during"
                case after = "after"
                case unknown = "unknown"
            }
        }
    }

    struct Table {
        let data:[CellTypeRaw]
        
        struct CellTypeRaw {
            let locationTitle:String
            let address:String
            let icon:String?
            let number:String?
            let color:AnnotationColor

            enum AnnotationColor:String {
                case orange = "Orange"
                case purpure = "Purpure"
                case green = "Green"
            }
        }
    }

    struct Regulate {
        let title:String
        let style:ButtonStyles
        let leftImage:LeftImage?
        var needSegueIndicator:Bool = false
        let actions:(()->(),(()->())?)

        
        enum ButtonStyles {
            case darkPurpure
            case lightPurpure
            case gray
            case green
        }
        
        struct LeftImage {
            let name:String
            let isOval:Bool
        }

    }
}




