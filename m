Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab0G1Guw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 02:50:52 -0400
Subject: Re: [PATCH 2/2] iw: Add antenna configuration commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <201007281107.04455.br1@einfach.org>
References: <20100727094932.27300.10253.stgit@tt-desk>
	 <20100727094937.27300.97445.stgit@tt-desk>
	 <1280225061.19098.8.camel@jlt3.sipsolutions.net>
	 <201007281107.04455.br1@einfach.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Jul 2010 08:50:48 +0200
Message-ID: <1280299848.3832.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-07-28 at 11:07 +0900, Bruno Randolf wrote:
> On Tue July 27 2010 19:04:21 Johannes Berg wrote:
> > On Tue, 2010-07-27 at 18:49 +0900, Bruno Randolf wrote:
> > > +	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
> > > +	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
> > > +		printf("\tAntenna: TX %d RX %d\n",
> > > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
> > > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
> > 
> > That's like the worst possible way to show the info.
> 
> which way would you prefer?

It occurred to me later that with the normal numbers we have (1 through
7) it won't matter much ... but still, I'd prefer %#x.

johannes

