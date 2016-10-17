//
//  MultipeerAdvertiser.swift
//  Multipeer-Connectivity-iOS
//
//  Created by Kohei Tabata on 10/13/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerAdvertiser: NSObject, MCNearbyServiceAdvertiserDelegate {

    static let sharedInstance: MultipeerAdvertiser = MultipeerAdvertiser()

    private var serviceAdvertiser: MCNearbyServiceAdvertiser?
    private weak var multipeerSession: MultipeerSession?

    //MARK: - internal

    func setup(with session: MultipeerSession) {
        self.multipeerSession            = session
        self.serviceAdvertiser           = MCNearbyServiceAdvertiser(peer: session.peerID, discoveryInfo: nil, serviceType: "com-nerd0geek1")
        self.serviceAdvertiser?.delegate = self
    }

    func startAdvertising() {
        serviceAdvertiser?.startAdvertisingPeer()
    }

    func stopAdvertising() {
        serviceAdvertiser?.stopAdvertisingPeer()
    }

    //MARK: - MCNearbyServiceAdvertiserDelegate

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        guard let multipeerSession = multipeerSession else {
            NSLog("multipeerSession is not set up")
            return
        }

        invitationHandler(true, multipeerSession.session)
    }

    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        NSLog("error:\(error)")
    }
}
