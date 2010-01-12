Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59653 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab0ALPY6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 10:24:58 -0500
Received: by iwn35 with SMTP id 35so15638098iwn.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 07:24:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4C8320.8060801@free.fr>
References: <995709e41001091103t43738262ibb2c4e0c4beab26d@mail.gmail.com>
	 <995709e41001120217r1b6b276ek70658a1142744142@mail.gmail.com>
	 <4B4C8320.8060801@free.fr>
Date: Tue, 12 Jan 2010 20:54:57 +0530
Message-ID: <995709e41001120724j7a6627b1g5d90df8fb658ceaa@mail.gmail.com>
Subject: Re: [Moblin Dev] Wireless is keep on disconnecting
From: Jaswinder Singh Rajput <jaswindermobile@gmail.com>
To: alainswb <alainswb@free.fr>, dev@moblin.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am CC this BUG to concern persons, I hope we get some feedback.

On Tue, Jan 12, 2010 at 7:41 PM, alainswb <alainswb@free.fr> wrote:
> Hi,
>
> I have the same problem with my eeepc s101 (1G ram). It's connect,
> disconnect, reconnect on big files and sometimes with no reasons. I suspect
> it's append when the download transfer is too fast, but in same time when I
> shutdown the WiFi button in the panel and I restart, I can download a 1G
> file (biggest file not tested)at 1M/s (it's fast for me ;)) with no
> problems. So ???
> It's a bug, the only way I fund it's to shutdwon and restart the wifi panel.
> Bad driver? Mismanagement ram?
> ps: sorry for my poor english
>
> #lspci
> 01:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
> Network Adapter (PCI-Express) (rev 01)
> #lsmod
> Module                  Size  Used by
> ath9k                 207096  0
>
>


01:00.0 Network controller: Atheros Communications Inc. AR9285
Wireless Network Adapter (PCI-Express) (rev 01)
	Subsystem: Foxconn International, Inc. Device e016
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 64 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at 57100000 (64-bit, non-prefetchable) [size=64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2- AuxCurrent=375mA PME(D0+,D1+,D2-,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
		Address: 00000000  Data: 0000
	Capabilities: [60] Express (v2) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <64us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0
<512ns, L1 <64us
			ClockPM- Surprise- LLActRep- BwNot-
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive-
BWMgmt- ABWMgmt-
		DevCap2: Completion Timeout: Not Supported, TimeoutDis+
		DevCtl2: Completion Timeout: 50us to 50ms, TimeoutDis-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-,
Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance-
ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -6dB
	Capabilities: [100] Advanced Error Reporting
		UESta:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UEMsk:	DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- UnxCmplt- RxOF-
MalfTLP- ECRC- UnsupReq- ACSViol-
		UESvrt:	DLP+ SDES+ TLP- FCP+ CmpltTO- CmpltAbrt- UnxCmplt- RxOF+
MalfTLP+ ECRC- UnsupReq- ACSViol-
		CESta:	RxErr+ BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		CEMsk:	RxErr- BadTLP- BadDLLP- Rollover- Timeout- NonFatalErr+
		AERCap:	First Error Pointer: 00, GenCap+ CGenEn- ChkCap+ ChkEn-
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
	Capabilities: [170] Power Budgeting <?>
	Kernel driver in use: ath9k
	Kernel modules: ath9k

> Le 12/01/2010 11:17, Jaswinder Singh Rajput a écrit :
>
> Hello,
>
> I keep on getting "Network Lost" message on moblin 2.1 when I transfer
> some big file. I am trying to understand Is it a feature or a Bug.
>
> My other machines are working great with Wireless even Windows XP
> running on Netbook never did this to me.
>
> Thank you,
> --
> Jaswinder Singh.
>
> On Sun, Jan 10, 2010 at 12:33 AM, Jaswinder Singh Rajput
> <jaswindermobile@gmail.com> wrote:
>
>
> Hello,
>
> When I transfer some big file from local network by using wireless
> (01:00.0 Network controller: Atheros Communications Inc. AR9285
> Wireless Network Adapter (PCI-Express) (rev 01)), wlan0 is keep on
> disconnecting like this :
>
>
> [ 3305.449552] wlan0: authenticated
> [ 3305.449566] wlan0: associate with AP 00:11:95:9e:df:f6
> [ 3305.462878] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471
> status=0 aid=1)
> [ 3305.462892] wlan0: associated
> [ 3329.021100] wlan0: no probe response from AP 00:11:95:9e:df:f6 -
> disassociating
> [ 3329.021405] wlan0: disassociating by local choice (reason=3)
> [ 3340.242387] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3340.442107] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3340.447582] wlan0: authenticated
> [ 3340.447596] wlan0: associate with AP 00:11:95:9e:df:f6
> [ 3340.460682] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471
> status=0 aid=1)
> [ 3340.460697] wlan0: associated
> [ 3352.280269] CE: hpet increasing min_delta_ns to 15000 nsec
> [ 3359.001082] wlan0: no probe response from AP 00:11:95:9e:df:f6 -
> disassociating
> [ 3359.001380] wlan0: disassociating by local choice (reason=3)
> [ 3370.221438] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3370.421102] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3370.427155] wlan0: authenticated
> [ 3370.427169] wlan0: associate with AP 00:11:95:9e:df:f6
> [ 3370.448915] wlan0: RX AssocResp from 00:11:95:9e:df:f6 (capab=0x471
> status=0 aid=1)
> [ 3370.448930] wlan0: associated
> [ 3399.014086] wlan0: no probe response from AP 00:11:95:9e:df:f6 -
> disassociating
> [ 3399.015644] wlan0: disassociating by local choice (reason=3)
> [ 3410.235983] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3410.436086] wlan0: authenticate with AP 00:11:95:9e:df:f6
> [ 3410.441540] wlan0: authenticated
> [ 3410.441554] wlan0: associate with AP 00:11:95:9e:df:f6
>
> How can I fix this problem.
>
> Thank you,
> --
> Jaswinder Singh.
>
>
>
> _______________________________________________
> Moblin dev Mailing List
> dev@moblin.org
>
> To manage or unsubscribe from this mailing list visit:
> http://lists.moblin.org/listinfo/dev or your user account on
> http://moblin.org once logged in.
>
> For more information on the Moblin Developer Mailing lists visit:
> http://moblin.org/community/mailing-lists
>
>
