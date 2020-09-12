//
//  Theme.swift
//  RGDropdownTextfield
//
//  Created by Rishu Gupta on 12/09/20.
//  Copyright © 2020 Rishu Gupta. All rights reserved.
//

import UIKit

func isIPhone() -> Bool {
    if UIDevice().userInterfaceIdiom == .phone {
        return true
    } else {
        return false
    }
}

struct Theme {
    
    struct Colors {
        static let Primary = UIColor(named: "PrimaryColor") ?? #colorLiteral(red: 0.9348487258, green: 0.2423158586, blue: 0.3526790142, alpha: 1)
        static let Secondary = UIColor(named: "SecondaryColor") ?? #colorLiteral(red: 0.9499316812, green: 0.4255635738, blue: 0.1344385445, alpha: 1)
        static let Accent = UIColor(named: "AcentColor") ?? #colorLiteral(red: 0.8840000033, green: 0.8100000024, blue: 0.7570000291, alpha: 1)
        
        static let Error = UIColor(named: "ErrorColor") ?? #colorLiteral(red: 1, green: 0.4120000005, blue: 0.3580000103, alpha: 1)
        static let Success = UIColor(named: "SuccessColor") ?? #colorLiteral(red: 0.2370000035, green: 0.7990000248, blue: 0.476000011, alpha: 1)
        static let Warning = UIColor(named: "WarningColor") ?? #colorLiteral(red: 1, green: 0.7459999919, blue: 0.3120000064, alpha: 1)
        static let TextActiveBorder = UIColor(named: "TextActiveColor") ?? #colorLiteral(red: 0.2860000134, green: 0.3140000105, blue: 0.3409999907, alpha: 1)
        static let TextInactiveBorder = UIColor(named: "TextInactiveColor") ?? #colorLiteral(red: 0.8080000281, green: 0.8309999704, blue: 0.8550000191, alpha: 1)
        
        static let TextPrimary = UIColor(named: "TextPrimaryColor") ?? #colorLiteral(red: 0.2595806718, green: 0.2596316338, blue: 0.2595774531, alpha: 1)
        static let TextSecondary = UIColor(named: "TextSecondaryColor") ?? #colorLiteral(red: 0.3582906723, green: 0.3583576083, blue: 0.3582865, alpha: 1)
        static let TextTertiary = UIColor(named: "TextTertiaryColor") ?? #colorLiteral(red: 0.7419999838, green: 0.7419999838, blue: 0.7419999838, alpha: 1)
        static let TextQuaternary = UIColor(named: "TextQuaternaryColor") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let TextQuinary = UIColor(named: "TextQuinaryColor") ?? #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
        static let TextSenary = UIColor(named: "TextSenaryColor") ?? #colorLiteral(red: 0.4901960784, green: 0.5098039216, blue: 0.5568627451, alpha: 1)
        static let TextPlaceholder = UIColor(named: "TextPlaceholderColor") ?? #colorLiteral(red: 0.8730638623, green: 0.873214066, blue: 0.8730544448, alpha: 1)
                
        
        static let TextBackground = UIColor(named: "TextBackgroundColor") ?? #colorLiteral(red: 0.9888326526, green: 0.9797794223, blue: 0.9794719815, alpha: 1)
        static let ButtonBackground = UIColor(named: "ButtonBackgroundColor") ?? #colorLiteral(red: 0.7450980392, green: 0.7450980392, blue: 0.7450980392, alpha: 1)
        static let ButtonTransparentBG = UIColor(named: "ButtonTransparentBGColor") ?? #colorLiteral(red: 0.8064273, green: 0.8065667748, blue: 0.8064184785, alpha: 1)
        static let BackgroundPrimary = UIColor(named: "BackgroundPrimaryColor") ?? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let BackgroundSecondary = UIColor(named: "BackgroundSecondaryColor") ?? #colorLiteral(red: 0.1764705882, green: 0.1764705882, blue: 0.1764705882, alpha: 0.4019350821)
        
        static let Shadow = UIColor(named: "ShadowColor") ?? #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        static let Selection = UIColor(named: "SelectionColor") ?? #colorLiteral(red: 0.90200001, green: 0.90200001, blue: 0.90200001, alpha: 1)
        static let SecondarySelection = UIColor(named: "SecondarySelectionColor") ?? #colorLiteral(red: 0.8941176471, green: 0.8941176471, blue: 0.8941176471, alpha: 1)
        static let Separator = UIColor(named: "SeparatorColor") ?? #colorLiteral(red: 0.7419999838, green: 0.7419999838, blue: 0.7419999838, alpha: 1)
        static let DateRangeSelection = UIColor(named: "DateRangeSelectionColor") ?? #colorLiteral(red: 1, green: 0.9450980392, blue: 0.9176470588, alpha: 1)
        
        static let TimelineStage1 = UIColor(named: "TimelineStage1Color") ?? #colorLiteral(red: 0.9647058824, green: 0.4392156863, blue: 0.5294117647, alpha: 1)
        static let TimelineStage2 = UIColor(named: "TimelineStage2Color") ?? #colorLiteral(red: 0.9882352941, green: 0.631372549, blue: 0.4235294118, alpha: 1)
        static let TimelineVerticalLine = UIColor(named: "TimelineVerticalLineColor") ?? #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
                
    }
    
    struct Font {
        enum Size {
            case ExtraSmall, Small, Medium, Regular, Large, ExtraLarge
            
            var value : CGFloat {
                switch self {
                case .ExtraSmall:
                    return isIPhone() ? 10 : 12
                case .Small:
                    return isIPhone() ? 12 : 13
                case .Medium:
                    return isIPhone() ? 14 : 17
                case .Regular:
                    return isIPhone() ? 16 : 24
                case .Large:
                    return isIPhone() ? 18 : 30
                case .ExtraLarge:
                    return isIPhone() ? 20 : 36
                }
            }
        }
        
        enum Style {
            case Bold, Regular, Semibold
            
            var name : String {
                switch self {
                case .Bold:
                    return "FontsFreeNetProximaNovaBold"
                case .Regular:
                    return "FontsFreeNetProximaNovaRegular"
                case .Semibold:
                    return "FontsFreeNetProximaNovaSbold"
                }
            }
        }
        
    }
    
    public static func getFont(style : Font.Style, size : Font.Size) -> UIFont {
        return UIFont(name: style.name, size: size.value) ?? UIFont.systemFont(ofSize: size.value)
    }
}

