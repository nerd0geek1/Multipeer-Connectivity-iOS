//
//  TopViewController.swift
//  Multipeer-Connectivity-iOS
//
//  Created by Kohei Tabata on 10/12/16.
//  Copyright © 2016 Kohei Tabata. All rights reserved.
//

import Speech
import UIKit

class TopViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var buttonsView: UIView!
    @IBOutlet weak var makeGroupButton: UIButton!
    @IBOutlet weak var joinGroupButton: UIButton!

    private let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private let audioEngine: AVAudioEngine = AVAudioEngine()

    //MARK: - lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        speechRecognizer?.delegate = self
        setupRecordButton()
        setupMakeGroupButton()
        setupJoinGroupButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        requestAuthorization()
    }

    //MARK: - private

    private func setupRecordButton() {
        recordButton.layer.cornerRadius = 50
        recordButton.layer.borderColor  = UIColor.gray.cgColor
        recordButton.layer.borderWidth  = 1
    }

    private func setupMakeGroupButton() {
        makeGroupButton.layer.cornerRadius = 5
        makeGroupButton.layer.borderColor  = UIColor.gray.cgColor
        makeGroupButton.layer.borderWidth  = 1
    }

    private func setupJoinGroupButton() {
        joinGroupButton.layer.cornerRadius = 5
        joinGroupButton.layer.borderColor  = UIColor.gray.cgColor
        joinGroupButton.layer.borderWidth  = 1
    }

    private func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
        }
    }

    private func startRecording() {
        refreshTask()

        let audioSession: AVAudioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(AVAudioSessionCategoryRecord)
        try? audioSession.setMode(AVAudioSessionModeMeasurement)
        try? audioSession.setActive(true, with: .notifyOthersOnDeactivation)
        guard let inputNode: AVAudioInputNode = audioEngine.inputNode else { return }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { (result, error) in
            if let result = result {
                if result.isFinal {
                    NSLog("test:\(result.bestTranscription.formattedString)")
                }
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        startAudioEngine()
    }

    private func refreshTask() {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
    }

    private func startAudioEngine() {
        audioEngine.prepare()

        try? audioEngine.start()
    }

    private func stopRecording() {
        if audioEngine.isRunning {
            audioEngine.inputNode?.removeTap(onBus: 0)
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
    }

    //MARK: - IBAction

    @IBAction
    func pressButton() {
        startRecording()
    }

    @IBAction
    func releaseButton() {
        stopRecording()
    }
}
