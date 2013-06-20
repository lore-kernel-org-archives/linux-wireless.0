Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:48034 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752800Ab3FTGjm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 02:39:42 -0400
Date: Thu, 20 Jun 2013 08:39:25 +0200
From: Ignacy Gawedzki <i@lri.fr>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Corey Richardson <corey@octayn.net>
Subject: Re: [ath9k-devel] ath9k_htc: station unable to authenticate
Message-ID: <20130620063925.GA3885@zenon.in.qult.net> (sfid-20130620_083945_127765_B49F5F9E)
References: <1DC40B07CD6EC041A66726C271A73AE61AA312F5@IRSMSX102.ger.corp.intel.com>
 <51C1B467.1030509@rempel-privat.de>
 <20130619140905.GA14079@zenon.in.qult.net>
 <1371651073.8349.19.camel@jlt4.sipsolutions.net>
 <51C1C95C.8030301@rempel-privat.de>
 <20130619175939.GA19405@zenon.in.qult.net>
 <20130619180354.GB19405@zenon.in.qult.net>
 <51C1FA76.3090109@rempel-privat.de>
 <20130619193316.GA29582@zenon.in.qult.net>
 <51C2942A.2080706@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51C2942A.2080706@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 20, 2013 at 07:33:30AM +0200, thus spake Oleksij Rempel:
> Am 19.06.2013 21:33, schrieb Ignacy Gawedzki:
> >I tested the thing with at least three different APs:
> >
> >   - Netgear DG834Gv4 with latest firmware.
> 
> this one is BG with Broadcom BCM4318. Is here original firmware or openwrt?

Original firmware, since OpenWRT doesn't support the ADSL chip.

> >   - Netgear DG834Gv5 (don't know which firmware and can't check at this time).
> 
> this is BG with Conexant CX94610
> 
> >   - hostapd (can't say which version at this time either) with the same
> >     ath9k_htc.
> 
> this one is actually BGN, did you configured it for N? Can you
> please provide your hostapd.conf.

I'll manage to get the configuration as soon as possible.  It seems the
association problem went away since I patched the drivers on the AP too, so
"unpatching" the drivers on the station is not enough to reproduce the
problem.  I'll unpatch the drivers on the AP and re-run the test.

> Do you have problems on all 3 configurations?

On both Netgears for sure.  For hostapd I'll confirm that in a little while.

>                                               Can you please test it
> with some N (HT) capable AP. But please, not with N-draft certified
> AP.

Is ath9k_htc N-capable?

-- 
I used to have a sig, but I've stopped smoking now.
