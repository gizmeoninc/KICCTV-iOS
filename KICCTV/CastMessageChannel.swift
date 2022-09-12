//
//  CastMessageChannel.swift
//  AnandaTV
//
//  Created by Firoze Moosakutty on 23/10/19.
//  Copyright © 2019 Gizmeon. All rights reserved.
//

import Foundation
import GoogleCast

protocol CastMessageChannelDelegate: NSObjectProtocol {
    func castChannel(_ channel: CastMessageChannel?, didReceiveMessage message: String?)
}

class CastMessageChannel: GCKCastChannel {
    weak var delegate: CastMessageChannelDelegate?

}
