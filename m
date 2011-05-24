Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65138 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1EXIyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 04:54:02 -0400
Received: by bwz15 with SMTP id 15so5417422bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 May 2011 01:54:01 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 24 May 2011 10:54:01 +0200
Message-ID: <BANLkTim6UVZQ5m1ou4bkEA2HpZHGqpY+3w@mail.gmail.com> (sfid-20110524_105407_886943_1BFA2F22)
Subject: low signal with atheros card
From: Leonardo Canducci <leonardo.canducci@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm running debian squeeze on some old PC with a PCI D-Link DWL-520
atheros card.

lspci --vv

00:0d.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+ Wireless Network Adapter (rev 01)
        Subsystem: D-Link System Inc AirPlus DWL-G520 Wireless PCI
Adapter (rev. B)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 9
        Region 0: Memory at dffe0000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: <access denied>
        Kernel driver in use: ath5k

With ath5k driver I have poor perfomance compared to any other
wireless device. Using iwconfig and wavemon I can see signal level is
low (-55dB) even close to my router where all other wireless devices
(linux laptops with broadcom and intel drivers) have full signal.

Is there anything I can do to get better results?
Should I expect better results with the madwifi driver?

Thanks!
-- 
Leonardo Canducci
