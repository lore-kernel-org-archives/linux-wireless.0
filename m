Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:51551 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab3K3TmW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Nov 2013 14:42:22 -0500
Received: from [192.168.1.100] ([93.218.116.213]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0MQiVh-1WCRGb1WrV-00U5Zx for
 <linux-wireless@vger.kernel.org>; Sat, 30 Nov 2013 20:42:20 +0100
Message-ID: <529A3F9B.6070306@rempel-privat.de> (sfid-20131130_204239_855817_EC397832)
Date: Sat, 30 Nov 2013 20:42:19 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Adam Williamson <awilliam@redhat.com>,
	linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
Subject: Re: Support for Atheros chipset with SDIO ID 0271:0418 ?
References: <1385838681.2566.6.camel@adam.happyassassin.net>
In-Reply-To: <1385838681.2566.6.camel@adam.happyassassin.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 30.11.2013 20:11, schrieb Adam Williamson:
> Hi, folks - I hope this is the appropriate place, it's as close as I
> could manage to Google myself :) I recently bought a Dell Venue 8 Pro -
> a Bay Trail / Valley View-based Intel tablet - to try and get Fedora
> running on it. Among the many things I'm currently fighting :), the
> wireless doesn't work - no driver is loaded, no interface appears at
> all. Using the Device Manager in Windows 8 I've managed to identify it
> as being attached via SDIO and having the device ID 0271:0418 . It calls
> itself a "Dell Wireless 1538", but by the ID and various other details
> about the Windows driver it's clearly a Qualcomm/Atheros part.
> 
> So the ath6kl-sdio driver in the kernel advertises support for:
> 
> alias:          sdio:c*v0271d0401*
> alias:          sdio:c*v0271d0400*
> alias:          sdio:c*v0271d0301*
> alias:          sdio:c*v0271d0300*
> 
> Looks pretty close, but no cigar. I'm having trouble finding any more
> information on the chipset than what I've outlined above. It seems most
> likely that it's a variant of the AR6004 for Dell, but that's just my
> best guess.
> 
> Is there any hope of getting support for this device in ath6kl or any
> other driver? Thanks!

If this device continued HIF/WMI tradition, then most probably it works
same way like ar5523, ath6kl-sdio or ath9k-htc do.
The question is, do all WMI commands present?
-- 
Regards,
Oleksij
