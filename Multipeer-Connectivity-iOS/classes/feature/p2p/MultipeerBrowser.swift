//
//  MultipeerBrowser.swift
//  Multipeer-Connectivity-iOS
//
//  Created by Kohei Tabata on 10/13/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerBrowser: NSObject, MCNearbyServiceBrowserDelegate {

    static let sharedInstance: MultipeerBrowser = MultipeerBrowser()

    private var serviceBrowser: MCNearbyServiceBrowser?
    private weak var multipeerSession: MultipeerSession?

    //MARK: - internal

    func setup(with session: MultipeerSession) {
        self.multipeerSession         = session
        self.serviceBrowser           = MCNearbyServiceBrowser(peer: session.peerID, serviceType: "com-nerd0geek1")
        self.serviceBrowser?.delegate = self
    }

    func startBrowsing() {
        serviceBrowser?.startBrowsingForPeers()
    }

    func stopBrowsing() {
        serviceBrowser?.stopBrowsingForPeers()
    }

    //MARK: - MCNearbyServiceBrowserDelegate

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        guard let multipeerSession = multipeerSession else {
            NSLog("multipeerSession is not set up")
            return
        }

        browser.invitePeer(peerID, to: multipeerSession.session, withContext: nil, timeout: 0)
    }

    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    }

    func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        NSLog("error:\(error)")
    }
}
