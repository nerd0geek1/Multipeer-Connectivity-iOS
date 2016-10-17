//
//  MultipeerSession.swift
//  Multipeer-Connectivity-iOS
//
//  Created by Kohei Tabata on 2016/10/17.
//  Copyright © 2016年 Kohei Tabata. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerSession: NSObject, MCSessionDelegate {

    static let sharedInstance: MultipeerSession = MultipeerSession()

    let peerID: MCPeerID = MCPeerID(displayName: UIDevice.current.name)
    let session: MCSession

    var didEstablishConnection: (() -> Void)?

    //MARK: - lifecycle

    override private init() {
        self.session = MCSession(peer: self.peerID)

        super.init()

        self.session.delegate = self
    }

    //MARK: - MCSessionDelegate

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            didEstablishConnection?()
        }
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession,
                 didReceive stream: InputStream,
                 withName streamName: String,
                 fromPeer peerID: MCPeerID) {
    }

    func session(_ session: MCSession,
                 didStartReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 with progress: Progress) {
    }

    func session(_ session: MCSession,
                 didFinishReceivingResourceWithName resourceName: String,
                 fromPeer peerID: MCPeerID,
                 at localURL: URL,
                 withError error: Error?) {
        NSLog("error:\(error)")
    }
}
