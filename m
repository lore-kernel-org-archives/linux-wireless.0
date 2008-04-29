Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:61126 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755781AbYD2Wez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Apr 2008 18:34:55 -0400
Message-ID: <4817A28E.2050309@lwfinger.net> (sfid-20080430_003452_312081_04CAD81C)
Date: Tue, 29 Apr 2008 17:34:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Gautam Iyer <gi1242@stanford.edu>, linux-wireless@vger.kernel.org
Subject: Re: b43 reduced performance in Linux-2.6.25
References: <20080429215629.GC17790@stanford.edu>
In-Reply-To: <20080429215629.GC17790@stanford.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gautam Iyer wrote:
> Hi All,
> 
> I saw a few threads about reduced performance in b43 in the 2.6.24 /
> 2.6.25_rcXX kernels, but couldn't manage to fix the problem myself:
> 
> On my system, using ndiswrapper and the windows drivers gives me about
> 1.5 times the performance of the in kernel b43 drivers.
> 
> Here are my system specs:
> 
>     Broadcom Corporation BCM4312 802.11a/b/g [14e4:4312] (rev 02)
>     Linux 2.6.25 (gentoo-sources-2.6.25-r1).
>     b43 wireless driver with firmware 410.2160 (2007-05-26 15:32:10)
> 
> I measured the performance by running "ttcp" between my Laptop and my
> router. Using b43 on my Laptop gives about 2MB/s reported, and using
> ndiswrapper gives me about 3MB/s under exactly the same situations.
> 
> Any ideas about what's going on? (I would be happy to provide you with
> any further specs on my computer).

Yes. Broadcom wrote the Windows drivers, but never gave the specifications to 
anyone else. Obvious those specs from their engineers are better than those 
from the _reverse_ engineers for your card. On my BCM4311/2 I get better 
throughput with the b43 driver than I get when running Windows. I _NEVER_ use 
ndiswrapper. Now that b43 works, why would I want to taint my kernel?

The only loss of performance that we look at is those that happen between 
release n and n+1. Those we call regressions and take them seriously.

The only specs that we are interested in are those that come from reverse 
engineering. If you can provide them, we are very interested.

Larry
