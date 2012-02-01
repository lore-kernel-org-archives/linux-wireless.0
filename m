Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4123 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091Ab2BAQKs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:10:48 -0500
Message-ID: <4F2963F8.9060804@broadcom.com> (sfid-20120201_171053_155434_EA08B29E)
Date: Wed, 1 Feb 2012 17:10:32 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "balbi@ti.com" <balbi@ti.com>
cc: "stefano.brivio@polimi.it" <stefano.brivio@polimi.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>
Subject: Re: Dell e6410 with b43
References: <20120201123324.GG20238@legolas.emea.dhcp.ti.com>
In-Reply-To: <20120201123324.GG20238@legolas.emea.dhcp.ti.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 01:33 PM, Felipe Balbi wrote:
> Hi all,
> 
> is Dell e6410's b43 wireless card supported by the open source driver ?
> 
> Here's lspci dump:
> 
> 02:00.0 Network controller [0280]: Broadcom Corporation BCM43224 802.11a/b/g/n [14e4:4353] (rev 01)
> 	Subsystem: Dell Wireless 1520 Half-size Mini PCIe Card [1028:000e]
> 	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
> 	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 	Latency: 0, Cache Line Size: 64 bytes
> 	Interrupt: pin A routed to IRQ 10
> 	Region 0: Memory at f4100000 (64-bit, non-prefetchable) [size=16K]
> 	Capabilities: [40] Power Management version 3
> 		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
> 		Status: D0 NoSoftRst+ PME-Enable- DSel=0 DScale=2 PME-
> 	Capabilities: [58] Vendor Specific Information: Len=78 <?>
> 	Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
> 		Address: 0000000000000000  Data: 0000
> 	Capabilities: [d0] Express (v1) Endpoint, MSI 00
> 		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <4us, L1 unlimited
> 			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
> 		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
> 			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
> 			MaxPayload 128 bytes, MaxReadReq 128 bytes
> 		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
> 		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <4us, L1 <64us
> 			ClockPM+ Surprise- LLActRep+ BwNot-
> 		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
> 			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
> 		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
> 
> It's at least not listed under http://linuxwireless.org/en/users/Devices/PCI
> 
> If it is supported, which firmware should I use ? (kernel is 3.3-rc2)
> 

It is also supported with b43, but you may need to select Kconfig option
for that.

Gr. AvS

