Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48013 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757433Ab0EKIu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:50:29 -0400
Subject: Re: [RFC PATCH 1/2] mac80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Bruno Randolf <br1@einfach.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	holgerschurig@gmail.com
In-Reply-To: <20100511083900.28289.43864.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
	 <20100511083900.28289.43864.stgit@tt-desk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 10:50:23 +0200
Message-ID: <1273567823.3669.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-11 at 17:39 +0900, Bruno Randolf wrote:

> +	[NL80211_ATTR_ANTENNA_TX] = { .type = NLA_U8 },
> +	[NL80211_ATTR_ANTENNA_RX] = { .type = NLA_U8 },
>  };

> +	tx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_TX]);
> +	rx_ant = nla_get_u8(info->attrs[NL80211_ATTR_ANTENNA_RX]);

> +	NLA_PUT_U32(msg, NL80211_ATTR_ANTENNA_TX, tx_ant);
> +	NLA_PUT_U32(msg, NL80211_ATTR_ANTENNA_RX, rx_ant);

That isn't right.

johannes

