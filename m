Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43805 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3CTVCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 17:02:42 -0400
Message-ID: <1363813359.9284.7.camel@jlt4.sipsolutions.net> (sfid-20130320_220246_629702_618F637C)
Subject: Re: [PATCH 3/4] mac80211: P2P add NOA settings
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 20 Mar 2013 22:02:39 +0100
In-Reply-To: <CAFED-j=tNHkbwt9R6qSBNtZ2pTFvtt5pzOaLOOPTf8Sxg5nvVQ@mail.gmail.com> (sfid-20130320_201407_184740_25A8644E)
References: <CAFED-j=tNHkbwt9R6qSBNtZ2pTFvtt5pzOaLOOPTf8Sxg5nvVQ@mail.gmail.com>
	 (sfid-20130320_201407_184740_25A8644E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +++ b/net/mac80211/cfg.c
> @@ -960,8 +960,11 @@ static int ieee80211_start_ap(struct wiphy
> *wiphy, struct net_device *dev,

same here.

Also, patch 3/4 need to be squashed since otherwise 3 doesn't compile.

johannes

