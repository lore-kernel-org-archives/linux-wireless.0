Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37015 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab1LBUVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 15:21:25 -0500
Subject: Re: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1322857169.4124.5.camel@jlt3.sipsolutions.net>
References: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
	 (sfid-20111202_052910_037002_B91C34E9) <1322817100.4162.0.camel@jlt3.sipsolutions.net>
	 <1322838068.24199.0.camel@wwguy-ubuntu>
	 <1322857169.4124.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 12:14:51 -0800
Message-ID: <1322856891.19783.1.camel@wwguy-ubuntu> (sfid-20111202_212128_681623_62E9043E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-02 at 12:19 -0800, Johannes Berg wrote:
> On Fri, 2011-12-02 at 07:01 -0800, wwguy wrote:
> > On Fri, 2011-12-02 at 01:11 -0800, Johannes Berg wrote:
> > > On Thu, 2011-12-01 at 23:29 -0500, Nikolay Martynov wrote:
> > > > Hi.
> > > > 
> > > >   I have an intel 5300 card running on latest compat-wireless.
> > > >   If I do:
> > > > echo "tx start 8" >
> > > > /sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status
> > > 
> > > Yikes. I think mac80211 should just reject that since it will never put
> > > traffic into that TID anyway.
> > > 
> > Johannes, are you going to help fix that :-)
> 
> I *think* this is the right fix. Do you agree? It fixes it for sure --
> but does it really not have any side effects? I'm pretty sure it doesn't
> since I looked at all the code just now ...
> 
initial look at it, I agree

Wey

