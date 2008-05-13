Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbYEMJpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 05:45:22 -0400
Date: Tue, 13 May 2008 02:45:16 -0700 (PDT)
Message-Id: <20080513.024516.248213393.davem@davemloft.net> (sfid-20080513_114525_070952_1FB32290)
To: johannes@sipsolutions.net
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1210669273.3646.51.camel@johannes.berg>
References: <1209936745.7304.16.camel@johannes.berg>
	<20080512.205224.12536510.davem@davemloft.net>
	<1210669273.3646.51.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>
Date: Tue, 13 May 2008 11:01:13 +0200

> Will you put in something like the patch that made dev_alloc_skb
> reserve more with the bridging headroom as well, or do you want (me)
> to look at routing first?

I'm trying to do this one set of changes at a time. :-)

I'll get to the netdev_alloc_skb() bits after this stuff
has had some time to cook.
