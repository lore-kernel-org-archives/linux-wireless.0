Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:5451 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754138Ab0G1CGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 22:06:55 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-038862813
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 11:06:53 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2] iw: Add antenna configuration commands
Date: Wed, 28 Jul 2010 11:07:04 +0900
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <20100727094932.27300.10253.stgit@tt-desk> <20100727094937.27300.97445.stgit@tt-desk> <1280225061.19098.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280225061.19098.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281107.04455.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue July 27 2010 19:04:21 Johannes Berg wrote:
> On Tue, 2010-07-27 at 18:49 +0900, Bruno Randolf wrote:
> > +	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
> > +	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
> > +		printf("\tAntenna: TX %d RX %d\n",
> > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
> > +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));
> 
> That's like the worst possible way to show the info.

which way would you prefer?

bruno
