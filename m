Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:53064 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757743Ab1LNR6I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Dec 2011 12:58:08 -0500
Date: Wed, 14 Dec 2011 11:58:04 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: Re: Problems associating with RTL8188CE
Message-ID: <20111214175804.GG19410@thinkpad-t410> (sfid-20111214_185813_866545_409F97F4)
References: <20111213194231.GA30788@thinkpad-t410>
 <4EE7B85E.3070802@lwfinger.net>
 <20111213212606.GB30788@thinkpad-t410>
 <4EE82CC6.2030307@lwfinger.net>
 <20111214162333.GB19410@thinkpad-t410>
 <4EE8D150.8090100@lwfinger.net>
 <20111214164902.GD19410@thinkpad-t410>
 <4EE8D5A1.7040600@lwfinger.net>
 <20111214171234.GE19410@thinkpad-t410>
 <4EE8E035.90501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EE8E035.90501@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 14, 2011 at 11:43:17AM -0600, Larry Finger wrote:
> Seth,
> 
> As expected, my RTL8188SE came right up.
> 
> The lspci -nnv details for my card are
> 
> 06:00.0 0280: 10ec:8176 (rev 01)
>         Subsystem: 10ec:8176
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast
> >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Latency: 0, Cache Line Size: 64 bytes
>         Interrupt: pin A routed to IRQ 21
>         Region 0: I/O ports at 4000 [size=256]
>         Region 2: Memory at f8000000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: <access denied>
>         Kernel driver in use: rtl8192ce
> 
> Does yours also have 10ec:8176 as the PCI ID?

Yes.

07:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8188CE 802.11b/g/n WiFi Adapter [10ec:8176] (rev 01)
	Subsystem: Realtek Semiconductor Co., Ltd. Device [10ec:8184]
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 17
	Region 0: I/O ports at 2000 [size=256]
	Region 2: Memory at f0100000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: <access denied>
	Kernel driver in use: rtl8192ce
	Kernel modules: rtl8192ce
