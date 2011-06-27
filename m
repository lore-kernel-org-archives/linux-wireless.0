Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53906 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab1F0Mqn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 08:46:43 -0400
Subject: Re: [RFC v3 2/3] nl80211: channel type attribute for IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexander Simon <alexander.simon@saxnet.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1308671544.2656.8.camel@alex-2> (sfid-20110621_175230_715106_4D770237)
References: <1308671129.2656.4.camel@alex-2>
	 <1308671544.2656.8.camel@alex-2> (sfid-20110621_175230_715106_4D770237)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 27 Jun 2011 14:46:46 +0200
Message-ID: <1309178806.3911.19.camel@jlt3.sipsolutions.net> (sfid-20110627_144825_983011_66EDE0CF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-06-21 at 17:52 +0200, Alexander Simon wrote:

> +	ibss.channel = rdev_freq_to_chan(rdev,
> +		nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]),
> +		ibss.channel_type);
> +	/*if (!ibss.channel ||

You must be joking.

johannes


