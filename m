Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1CAMTG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 07:19:06 -0500
Subject: Re: [PATCH 6/9] [cfg80211] no operation list (NOL) support
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
In-Reply-To: <201102281749.55214.bernhard.schmidt@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
	 <201102281749.55214.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 13:19:04 +0100
Message-ID: <1298981944.6015.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 17:49 +0100, Bernhard Schmidt wrote:

> +		chan->flags &= ~IEEE80211_CHAN_RADAR_INTERFERENCE;
> +		if (set)
> +			chan->flags |= IEEE80211_CHAN_RADAR_INTERFERENCE;

else would be better (not racy)

johannes

