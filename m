Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hosting.visp.net.lb ([194.146.153.11]:37361 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755390AbZJ0BGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 21:06:53 -0400
From: Denys Fedoryschenko <denys@visp.net.lb>
To: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Subject: ath5k, too high output power?
Date: Tue, 27 Oct 2009 02:59:09 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910270259.09787.denys@visp.net.lb>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have laptop with ath5k card, and just tried to run it with ath5k driver.
I notice strange thing:

lappi ~ # iw phy phy0 info
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (20.0 dBm)
                        * 2417 MHz [2] (20.0 dBm)
                        * 2422 MHz [3] (20.0 dBm)

I guess it is too high. I am not sure it is actual value, but if it is right 
and actual value, then i am exceeding local regulations.

I have simple spectrum analyzer (spectran), and i can try to test actual 
output power if required.

Another thing, is it possible to change antenna output?


Hardware:
01:00.0 Ethernet controller: Atheros Communications Inc. AR242x 802.11abg 
Wireless PCI Express Adapter (rev 01)
        Subsystem: Hewlett-Packard Company Device 137a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 128 bytes
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at d1300000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [50] Message Signalled Interrupts: Mask- 64bit- 
Count=1/1 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [60] Express (v1) Legacy Endpoint, MSI 00
                DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, 
L1 <64us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                DevSta: CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- 
TransPend-
                LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency 
L0 <512ns, L1 <64us
                        ClockPM- Suprise- LLActRep- BwNot-
                LnkCtl: ASPM Disabled; RCB 128 bytes Disabled- Retrain- 
CommClk-
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [90] MSI-X: Enable- Mask- TabSize=1
                Vector table: BAR=0 offset=00000000
                PBA: BAR=0 offset=00000000
        Capabilities: [100] Advanced Error Reporting
                UESta:  DLP- SDES- TLP- FCP- CmpltTO+ CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF- MalfTLP- ECRC- UnsupReq- ACSVoil-
                UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- 
RxOF+ MalfTLP+ ECRC- UnsupReq- ACSVoil-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                AERCap: First Error Pointer: 0e, GenCap+ CGenEn- ChkCap+ 
ChkEn-
        Capabilities: [140] Virtual Channel <?>
        Kernel driver in use: ath5k
        Kernel modules: ath5k
