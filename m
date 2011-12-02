Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:51110 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754298Ab1LBPHm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Dec 2011 10:07:42 -0500
Subject: Re: iwlwifi: kernel panic if try to open tid with large index (>=8)
From: wwguy <wey-yi.w.guy@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1322817100.4162.0.camel@jlt3.sipsolutions.net>
References: <CALGY4fvH5EbBm1oSBHsmXw5r5yfWMQ4yJyVyBx3y70FOEVeT6A@mail.gmail.com>
	 (sfid-20111202_052910_037002_B91C34E9)  <1322817100.4162.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Dec 2011 07:01:08 -0800
Message-ID: <1322838068.24199.0.camel@wwguy-ubuntu> (sfid-20111202_160745_807806_67D59E5F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-12-02 at 01:11 -0800, Johannes Berg wrote:
> On Thu, 2011-12-01 at 23:29 -0500, Nikolay Martynov wrote:
> > Hi.
> > 
> >   I have an intel 5300 card running on latest compat-wireless.
> >   If I do:
> > echo "tx start 8" >
> > /sys/kernel/debug/ieee80211/phy0/netdev\:wlan1/stations/XX\:XX\:XX\:XX\:XX\:XX/agg_status
> 
> Yikes. I think mac80211 should just reject that since it will never put
> traffic into that TID anyway.
> 
Johannes, are you going to help fix that :-)

Wey

