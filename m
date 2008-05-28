Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4129 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753997AbYE1M66 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2008 08:58:58 -0400
Date: Tue, 27 May 2008 20:28:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Jerry Quinn <jlquinn@optonline.net>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com,
	mickflemm@gmail.com
Subject: Re: ath5k can't connect on 5424
Message-ID: <20080528002814.GF7779@tuxdriver.com> (sfid-20080528_145923_344089_C2DA1FCE)
References: <4838A467.1000700@optonline.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4838A467.1000700@optonline.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 24, 2008 at 07:27:35PM -0400, Jerry Quinn wrote:
> Hi.  I just installed compat-wireless 2008-05-24.
>
> The good news is that ath5k now loads into the kernel and can talk to the 
> chip.  However, beyond that, the device doesn't do anything.  During 
> modprobe ath5k, I get
>
>
> ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
> PCI: Setting latency timer of device 0000:03:00.0 to 64
> ath5k_pci 0000:03:00.0: registered as 'phy1'
> phy1: Selected rate control algorithm 'pid'
> ath5k phy1: Atheros AR5424 chip found (MAC: 0xa3, PHY: 0x61)
> udev: renamed network interface wlan0 to ath0
>
> The pci id for the chip is 168c:1014 (rev 01).  This is an IBM Thinkpad 
> T60p, running Debian testing with kernel 2.6.25-2-686, the latest dist 
> kernel available.
>
> When I try to bring up the interface I just get a link is not ready message 
> in the kernel log with no other info.  Also, iwlist ath0 scan gives me no 
> results either (I did ifconfig ath0 up beforehand).
>
> Let me know if there's any further diagnosis I can provide to help out.

You might wish to post the results of running the ath_info tool
available from the madwifi project (sorry, I don't have the URL handy).

John
-- 
John W. Linville
linville@tuxdriver.com
