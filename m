Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57987 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984Ab0CLQas (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Mar 2010 11:30:48 -0500
Date: Fri, 12 Mar 2010 11:20:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Janne Tanskanen <jannejt@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: rt2500pci master mode and hostapd
Message-ID: <20100312162040.GA17689@tuxdriver.com>
References: <4ADF4285.7010405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4ADF4285.7010405@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 08:19:01PM +0300, Janne Tanskanen wrote:
> Hi! I build a wireless access point using a-link wl54pc (pcmcia card,  
> rt2500pci module) and hostapd 0.6.9 with kernel version 2.6.32-rc5.  
> Problem is that even tho hostapd starts and iwconfig shows wlan0 in  
> master mode, other computers cant find the wireless network.
>
> I found a working patch from here:  
> http://rt2x00.serialmonkey.com/phpBB/viewtopic.php?p=32632#p32632 and  
> all works now with it applied to vanilla kernel. Just wanted to post  
> this to the mailing list and ask why it's not added to mainline rt2x00  
> kernel tree yet? Patch on forum is from May, almost half year ago.  
> Hopefully it'll be included to mainline kernel asap.

This is an old one -- sorry if no one got back to you sooner!
It looks to me like the equivalent of the patch you cited is available
in 2.6.34-rc1 (if not before) -- look for DRIVER_REQUIRE_DMA and
rt2x00queue_align_frame.  There were some changes between 2.6.32-rc5
and now, but I'm not sure if they affect things for your or not.

Could you try 2.6.34-rc1 and see if things are working for you?

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
