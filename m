Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56833 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2IJIjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 04:39:33 -0400
Subject: Re: Regression associated with commit c8628155ece3 - "tcp: reduce
 out_of_order memory use"
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>
In-Reply-To: <503BB49C.5010402@lwfinger.net>
References: <50369925.3050705@lwfinger.net>
	 <1345757200.5904.1890.camel@edumazet-glaptop> <50378B35.80307@lwfinger.net>
	 <20120824.111948.680531915905273128.davem@davemloft.net>
	 <5037A4B0.3080208@lwfinger.net>
	 <1345825095.19483.19.camel@edumazet-glaptop>
	 <1345825432.19483.20.camel@edumazet-glaptop> <5037B2AC.50704@lwfinger.net>
	 <1345830424.19483.69.camel@edumazet-glaptop>
	 <503BB49C.5010402@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Sep 2012 10:39:26 +0200
Message-ID: <1347266366.1234.1267.camel@edumazet-glaptop> (sfid-20120910_103941_802786_94BC7EB8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-08-27 at 12:55 -0500, Larry Finger wrote:

> I have prepared a patch to fix all the unchecked allocations.
> 
> Over the weekend I made some progress. To test the latest vendor driver, I 
> installed a 32-bit system. Their driver is not compatible with a 64-bit system. 
> I found that not only did the vendor driver work with secure sites, but so did 
> the in-kernel version. I now have tcpdump output for the 32-bit case that works, 
> and the 64-bit case that fails. It seems likely that I missed some 32/64 bit 
> incompatibility when I did the conversion.
> 
> Thanks for all your help in trying to resolve this issue.
> 
> Larry
> 
> 

Hi Larry

It appears I have a D-Link N300 (DWA-131) nano USB adapter, using
staging/rtl8712 driver.

I tried many kernel versions (including 3.3) and none seems to work
reliably.

Sometime, I have some traffic but only for about 50 frames...
It might be because my access point is a netgear wndr3800, because I
have following warning a bit before the freezes :

r8712u: [r8712_got_addbareq_event_callback] mac = 20:4e:7f:5a:cd:30, sea = 80, tid = 0

Thanks


