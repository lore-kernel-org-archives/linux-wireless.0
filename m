Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57244 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794AbaJIJof (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2014 05:44:35 -0400
Message-ID: <1412847872.1828.40.camel@jlt4.sipsolutions.net> (sfid-20141009_114438_818930_ED1B1424)
Subject: Re: [PATCH 2/3] mac-hwsim:  add ethtool stats support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 09 Oct 2014 11:44:32 +0200
In-Reply-To: <5433EF3A.5090504@candelatech.com>
References: <1411680140-20208-1-git-send-email-greearb@candelatech.com>
		 <1411680140-20208-2-git-send-email-greearb@candelatech.com>
		 (sfid-20140925_232229_629577_D0F1A28C) <1412671568.1825.1.camel@jlt4.sipsolutions.net>
	 <5433EF3A.5090504@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 06:48 -0700, Ben Greear wrote:
> On 10/07/2014 01:46 AM, Johannes Berg wrote:
> > On Thu, 2014-09-25 at 14:22 -0700, greearb@candelatech.com wrote:
> >
> >> +static const char mac80211_hwsim_gstrings_stats[][ETH_GSTRING_LEN] = {
> >> +	"tx_pkts_nic",
> >> +	"tx_bytes_nic",
> >> +	"rx_pkts_nic",
> >> +	"rx_bytes_nic",
> >> +	"d_tx_dropped",
> >> +	"d_tx_failed",
> >> +	"d_ps_mode",
> >> +	"d_group",
> >> +	"d_tx_power",
> >
> > What's that d_ prefix?
> 
> Stats from the driver v/s from the mac80211 stack.  Basically, it
> mimics how I did ath9k, ath9k_htc, and ath10k stats (though
> not sure ath10k made it upstream yet).
> 
> The first 4 match those wifi drivers as well as some Intel wired
> NICs.
> 
> It doesn't matter a huge amount if you want to change the names,
> but it makes user-space stats reporting easier if you would leave
> them the same...

Ok, no problem. Can you resend though with the prefixes etc?

johannes

