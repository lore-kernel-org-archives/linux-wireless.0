Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47279 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007Ab1LNRnL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:43:11 -0500
Received: by vbbfc26 with SMTP id fc26so816281vbb.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Dec 2011 09:43:11 -0800 (PST)
Message-ID: <4EE8E035.90501@lwfinger.net> (sfid-20111214_184315_356004_745B2E8F)
Date: Wed, 14 Dec 2011 11:43:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
References: <4ECB028E.3030809@lwfinger.net> <20111122022008.GA17661@thinkpad-t410> <20111213194231.GA30788@thinkpad-t410> <4EE7B85E.3070802@lwfinger.net> <20111213212606.GB30788@thinkpad-t410> <4EE82CC6.2030307@lwfinger.net> <20111214162333.GB19410@thinkpad-t410> <4EE8D150.8090100@lwfinger.net> <20111214164902.GD19410@thinkpad-t410> <4EE8D5A1.7040600@lwfinger.net> <20111214171234.GE19410@thinkpad-t410>
In-Reply-To: <20111214171234.GE19410@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seth,

As expected, my RTL8188SE came right up.

The lspci -nnv details for my card are

06:00.0 0280: 10ec:8176 (rev 01)
         Subsystem: 10ec:8176
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- 
<MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 64 bytes
         Interrupt: pin A routed to IRQ 21
         Region 0: I/O ports at 4000 [size=256]
         Region 2: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: <access denied>
         Kernel driver in use: rtl8192ce

Does yours also have 10ec:8176 as the PCI ID?

Larry

