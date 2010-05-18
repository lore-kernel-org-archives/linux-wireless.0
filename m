Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51945 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754166Ab0ERQ2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 12:28:12 -0400
Date: Tue, 18 May 2010 18:28:09 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: b43: force_pio must be set in your kernel conf
In-Reply-To: <4BE2E219.1080806@lwfinger.net>
Message-ID: <alpine.LSU.2.01.1005181827070.28059@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1005061707140.32387@obet.zrqbmnf.qr> <4BE2E219.1080806@lwfinger.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thursday 2010-05-06 17:36, Larry Finger wrote:
>On 05/06/2010 10:16 AM, Jan Engelhardt wrote:

>> b43-phy0 ERROR: Fatal DMA error: 0x400, 0x0, 0x0, 0x0, 0x0, 0x0
>> b43-phy0 ERROR: This device does not support DMA on your system. Please 
>> use PIO instead.
>> b43-phy0 ERROR: CONFIG_B43_FORCE_PIO must be set in your kernel 
>> configuration.
>> ADDRCONF(NETDEV_UP): wlan0: link is not ready
>> 
>> So, can I get PIO mode for free without recompiling? (Since 
>> CONFIG_B43_PIO=y already.) What other info needs to be provided to help 
>> resolve this?
>> 
>> System is a 2.6.33.2-x86_64.
>
>In the latest mainline kernel (2.6.34-rc6), the fallback to PIO is
>automatic. For a 2.6.33 kernel, you will need to rebuild the kernel or
>install the latest compat-wireless package. Your distro may already
>provide it.
>
>We are working on this problem. Keep watching this list for trial
>patches. Unfortunately, none of the developers have a machine that
>suffers from this problem. It seems to be associated with Intel
>processors (mostly netbooks with Atom chips) and the Phoenix BIOS.

Seems so. 2.6.34 works, so everything's fine now.
Thanks!
