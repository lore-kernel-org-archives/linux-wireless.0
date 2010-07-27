Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51714 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0G0KEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 06:04:24 -0400
Subject: Re: [PATCH 2/2] iw: Add antenna configuration commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20100727094937.27300.97445.stgit@tt-desk>
References: <20100727094932.27300.10253.stgit@tt-desk>
	 <20100727094937.27300.97445.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 12:04:21 +0200
Message-ID: <1280225061.19098.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-27 at 18:49 +0900, Bruno Randolf wrote:

> +	if (tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX] &&
> +	    tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]) {
> +		printf("\tAntenna: TX %d RX %d\n",
> +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_TX]),
> +		       nla_get_u8(tb_msg[NL80211_ATTR_WIPHY_ANTENNA_RX]));

That's like the worst possible way to show the info.

johannes

