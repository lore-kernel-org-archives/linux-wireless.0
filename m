Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:43411 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756214Ab2AJNEY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jan 2012 08:04:24 -0500
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1RkbNG-00028m-0B
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 14:04:22 +0100
Received: from localhost ([::1]:40278 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkbNF-0006Ji-Sd
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 14:04:21 +0100
Received: from [195.4.92.14] (port=43054 helo=4.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1RkbL8-0005J4-0z
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 14:02:10 +0100
Received: from p4fde00e1.dip0.t-ipconnect.de ([79.222.0.225]:60078 helo=mail.maya.org)
	by 4.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1RkbL7-0000tL-Jk
	for linux-wireless@vger.kernel.org; Tue, 10 Jan 2012 14:02:09 +0100
Message-Id: <201201101301.q0AD1qSK004871@mail.maya.org> (sfid-20120110_140619_383916_427887A8)
Date: Tue, 10 Jan 2012 14:01:52 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
In-Reply-To: <CAGXE3d9usjQB+9jkBPgtvL6fT8L84ZzDQQ3UqHyMdb+PRfhrKA@mail.gmail.com>
References: <4EFF12D9.3010602@01019freenet.de> <2766356.70ylY68Gqi@helmutmobil.site> <4F040FEA.3080703@01019freenet.de> <1408490.qSFZVkU7fA@helmutmobil.site> <4F0562DF.3000200@dualc.maya.org> <CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com> <4F0AEBAB.9020104@01019freenet.de> <CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com> <201201100803.q0A83nsQ003757@mail.maya.org> <CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com> <201201101156.q0ABuS87004643@mail.maya.org> <CAGXE3d9usjQB+9jkBPgtvL6fT8L84ZzDQQ3UqHyMdb+PRfhrKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Helmut Schaa schrieb:
[...]
> So this looks good to me although the broken tx status for BAR frames
> is for sure a rt2800pci problem (or even a hw issue).

Sorry - What do you mean with "hw issue"? Is my hw broken? Or is
it a specific "behavior" of exactly this device:


05:07.0 Network controller: RaLink RT2800 802.11n PCI
        Subsystem: Linksys Device 0067
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fdae0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: rt2800pci


Kind regards,
Andreas
