Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49617 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2CGR37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 12:29:59 -0500
Message-ID: <4F579B14.4020109@openwrt.org> (sfid-20120307_183002_230875_9B85E8FF)
Date: Wed, 07 Mar 2012 18:29:56 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kim_Lidstr=F6m?= <dexter@lacto.se>
CC: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [ath9k-devel] "Failed to stop Tx DMA" and "Could not stop RX"
 with AR9485
References: <4F4E9A36.2080809@lacto.se>
In-Reply-To: <4F4E9A36.2080809@lacto.se>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-02-29 10:35 PM, Kim Lidström wrote:
> Hello!
> A while ago I had a situation where my AR9485 would lock up the kernel
> so bad and two very nice guys(Mohammed Shafi and Adrian.. Uhm.. Sorry I
> forgot his last name) were very patient in helping me and trying to
> debug it through patches, etc. Nothing worked.
> Eventually, though, I noticed that when I removed the atl1c module my
> wlan started working. "Awesome!" I thought... Until I noticed this other
> problem.
> 
> Once in a while, seemingly at random, the wlan dies with the error
> messages in the title. And I can't possibly restore it without
> restarting the computer.
> 
> With this message I have attached a log with the error messages.
> This has been a problem since.. Uhm.. Kernel 3.2.something and I'm
> currently running 3.2.8.
> For some reason it happened at least 3-4 times shortly after each other
> today - so I thought I might ask on here what's happening.
Please try this patch with powersave enabled, using a recent
compat-wireless build (3.3 or linux-next based):
http://nbd.name/ps-fix.patch

- Felix
