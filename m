Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3758 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab2BAQJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:09:22 -0500
Message-ID: <4F2963A9.1020100@broadcom.com> (sfid-20120201_171059_386769_5E5A3772)
Date: Wed, 1 Feb 2012 17:09:13 +0100
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

It is. See http://linuxwireless.org/en/users/Drivers/brcm80211

The firmware is available in the linux-firmware repository on
git.kernel.org. See
http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=summary

Gr. AvS

