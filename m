Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29433 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0GXG2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jul 2010 02:28:19 -0400
Subject: Re: ath9k - D-link DWA-552
From: Pavel Roskin <proski@gnu.org>
To: Andy Pyles <andy.pyles@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimnFGidxLvnR+=WXykQyf4NNAJBkxuqZ3HWRdeh@mail.gmail.com>
References: <AANLkTil3u8uFbH7WyPuvqu0wee4KsojqPUsAH2kupZhJ@mail.gmail.com>
	 <1279936945.27462.2.camel@mj>
	 <AANLkTimnFGidxLvnR+=WXykQyf4NNAJBkxuqZ3HWRdeh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Jul 2010 02:28:12 -0400
Message-ID: <1279952892.31905.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-07-23 at 22:30 -0400, Andy Pyles wrote:
> Hi Pavel,
> 
> Incidentally this is the output after adding that id to pci.c:
> 
> [ 1211.423855] Backport based on linux-next.git next-20100720
> [ 1211.437076] cfg80211: World regulatory domain updated:
> [ 1211.437080]     (start_freq - end_freq @ bandwidth),
> (max_antenna_gain, max_eirp)
> [ 1211.437084]     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 1211.437087]     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [ 1211.437089]     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
> [ 1211.437092]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 1211.437095]     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
> [ 1211.447705] ath9k 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> [ 1211.447794] ath9k 0000:05:02.0: Failed to initialize device
> [ 1211.447830] ath9k 0000:05:02.0: PCI INT A disabled
> [ 1211.447859] ath9k: probe of 0000:05:02.0 failed with error -95

You may want to post it to ath9k-devel@lists.ath9k.org

It looks like a hardware problem.  Either the device is broken, or it's
an experimental chip that is not supported by ath9k.  There have been
patches removing support for cards that have never been sold (or were
not supposed to be sold).  Maybe your card ended up with an experimental
chip by mistake.

-- 
Regards,
Pavel Roskin
