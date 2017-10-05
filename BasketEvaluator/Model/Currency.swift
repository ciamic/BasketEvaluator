//
//  Currency.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import Foundation

/// The Currency struct represents a Currency via it's name and code.
struct Currency {
    
    let name: String
    let code: CurrencyCode
    
    // MARK: - Convenience
    
    /// Convenience function to create Currencies from JSON results.
    static func currencies(fromResults results: [String:AnyObject]) -> [Currency] {
        var currencies = [Currency]()
        if let currenciesDictionary = results[CurrencyJSON.Currencies] as? [String:String] {
            currencies.append(contentsOf: currenciesDictionary.flatMap({
                if let currencyCode = CurrencyCode(rawValue: $0.key) {
                    return Currency(name: $0.value, code: currencyCode)
                }
                return nil // invalid / not supported currency code in the JSON
            }))
        }
        
        return currencies
    }

}

/// The enum of the supported currency codes.
/// Using the String as raw type, we get a free failable initializer
/// (i.e. we can init using the code as string and, if not available in the list, get nil as result).
enum CurrencyCode: String {
    
    case AED = "AED"
    case AFN
    case ALL
    case AMD
    case ANG
    case AOA
    case ARS
    case AUD
    case AWG
    case AZN
    case BAM
    case BBD
    case BDT
    case BGN
    case BHD
    case BIF
    case BMD
    case BND
    case BOB
    case BRL
    case BSD
    case BTC
    case BTN
    case BWP
    case BYN
    case BYR
    case BZD
    case CAD
    case CDF
    case CHF
    case CLF
    case CLP
    case CNY
    case COP
    case CRC
    case CUC
    case CUP
    case CVE
    case CZK
    case DJF
    case DKK
    case DOP
    case DZD
    case EGP
    case ERN
    case ETB
    case EUR
    case FJD
    case FKP
    case GBP
    case GEL
    case GGP
    case GHS
    case GIP
    case GMD
    case GNF
    case GTQ
    case GYD
    case HKD
    case HNL
    case HRK
    case HTG
    case HUF
    case IDR
    case ILS
    case IMP
    case INR
    case IQD
    case IRR
    case ISK
    case JEP
    case JMD
    case JOD
    case JPY
    case KES
    case KGS
    case KHR
    case KMF
    case KPW
    case KRW
    case KWD
    case KYD
    case KZT
    case LAK
    case LBP
    case LKR
    case LRD
    case LSL
    case LTL
    case LVL
    case LYD
    case MAD
    case MDL
    case MGA
    case MKD
    case MMK
    case MNT
    case MOP
    case MRO
    case MUR
    case MVR
    case MWK
    case MXN
    case MYR
    case MZN
    case NAD
    case NGN
    case NIO
    case NOK
    case NPR
    case NZD
    case OMR
    case PAB
    case PEN
    case PGK
    case PHP
    case PKR
    case PLN
    case PYG
    case QAR
    case RON
    case RSD
    case RUB
    case RWF
    case SAR
    case SBD
    case SCR
    case SDG
    case SEK
    case SGD
    case SHP
    case SLL
    case SOS
    case SRD
    case STD
    case SVC
    case SYP
    case SZL
    case THB
    case TJS
    case TMT
    case TND
    case TOP
    case TRY
    case TTD
    case TWD
    case TZS
    case UAH
    case UGX
    case USD
    case UYU
    case UZS
    case VEF
    case VND
    case VUV
    case WST
    case XAF
    case XAG
    case XAU
    case XCD
    case XDR
    case XOF
    case XPF
    case YER
    case ZAR
    case ZMK
    case ZMW
    case ZWL
    
}
