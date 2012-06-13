Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37817 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2FMGCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 02:02:42 -0400
Message-ID: <1339567354.4519.3.camel@jlt3.sipsolutions.net> (sfid-20120613_080246_094005_663DA5DB)
Subject: Re: Why "iwlwifi: read multiple MAC addresses"?
From: Johannes Berg <johannes@sipsolutions.net>
To: Lekensteyn <lekensteyn@gmail.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 08:02:34 +0200
In-Reply-To: <3484697.jSSpon72n2@penguin> (sfid-20120612_220734_681638_D9517088)
References: <3586963.qbQ3i1FPTG@penguin>
	 <1339531131.4531.22.camel@jlt3.sipsolutions.net>
	 <3484697.jSSpon72n2@penguin> (sfid-20120612_220734_681638_D9517088)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-12 at 22:07 +0200, Lekensteyn wrote:
> On Tuesday 12 June 2012 21:58:51 Johannes Berg wrote:
> > On Tue, 2012-06-12 at 15:11 +0200, Lekensteyn wrote:
> > > Looking at a dump provided by
> > > /sys/kernel/debug/cfg80211/phy0/iwlwifi/data/nvm, I see that the 16-bit
> > > word at 0x98 contains the value 4. What does this mean?
> > The 4 actually means that there are 4 addresses assigned to this device,
> > for use in P2P scenarios etc. We only support 2 virtual interfaces in
> > Linux today, so we don't expose 4 (though we probably could.)
> > 
> > > Can this break something?
> > 
> > No.
> 
> Okay, thanks for your quick answer. I have noticed that the first address is 
> stored at 0x3A while the second one is stored at 0x92. Did you make an 
> assumption that this address is other address + 1?

That's how it was specified.

johannes

