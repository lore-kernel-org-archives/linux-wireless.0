Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:53067 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbXLWBqF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 20:46:05 -0500
Received: from ssnt2.quns.cam.ac.uk ([131.111.255.37]:46461 helo=neotoaster.lan)
	by ppsw-1.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.151]:25)
	with esmtpsa (PLAIN:ssnt2) (TLSv1:DHE-RSA-AES256-SHA:256)
	id 1J6FTF-0007EB-3t (Exim 4.67) for linux-wireless@vger.kernel.org
	(return-path <ssnt2@hermes.cam.ac.uk>); Sun, 23 Dec 2007 01:17:37 +0000
From: Shawn Tan <ssnt2@eng.cam.ac.uk>
Reply-To: ssnt2@eng.cam.ac.uk
To: linux-wireless@vger.kernel.org
Subject: B43 not working
Date: Sun, 23 Dec 2007 01:17:35 +0000
MIME-Version: 1.0
Message-Id: <200712230117.35920.ssnt2@eng.cam.ac.uk> (sfid-20071223_014616_346516_D6422003)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

B43 still doesn't work for me. Let me know if any additional information from 
me will help.

dmesg:

[40699.800000] PCI: Setting latency timer of device 0000:30:00.0 to 64
[40699.840000] ssb: SPROM revision 3 detected.
[40699.860000] ssb: Sonics Silicon Backplane found on PCI device 0000:30:00.0
[40699.876000] b43-phy0: Broadcom 4311 WLAN found
[40700.044000] phy0: Failed to select rate control algorithm
[40700.044000] phy0: Failed to initialize rate control algorithm
[40700.080000] b43: probe of ssb0:0 failed with error -2

lspci -vvn:

30:00.0 0280: 14e4:4312 (rev 02)
        Subsystem: 103c:1371
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at c8000000 (64-bit, non-prefetchable) [size=16K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-
        Capabilities: [58] Vendor Specific Information
        Capabilities: [e8] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [d0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn+ AtnInd+ PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0
                Link: Latency L0s <4us, L1 <64us
                Link: ASPM L0s L1 Enabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x

-- 
with metta,
Shawn Tan

Centre for Advanced Photonics and Electronics
Department of Engineering, University of Cambridge
9 JJ Thomson Avenue, Cambridge CB3 0FA, UK.
