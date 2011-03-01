Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53697 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab1CAMLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 07:11:38 -0500
Subject: Re: [PATCH 1/9] [mac80211] add method to access oper chan
From: Johannes Berg <johannes@sipsolutions.net>
To: Bernhard Schmidt <bernhard.schmidt@saxnet.de>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com,
	nbd@openwrt.org, dubowoj@neratec.com, zefir.kurtisi@neratec.com,
	simon.wunderlich@saxnet.de
In-Reply-To: <201102281746.23102.bernhard.schmidt@saxnet.de>
References: <201102281740.37036.bernhard.schmidt@saxnet.de>
	 <201102281746.23102.bernhard.schmidt@saxnet.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 13:11:30 +0100
Message-ID: <1298981490.6015.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-02-28 at 17:46 +0100, Bernhard Schmidt wrote:
> I'm really not sure about this.. is there another/better way to
> access the current channel last set on a wiphy?

Very soon, there will not be a single operating channel. So this needs
to be per netdev. But for most interface types, cfg80211 already knows
the channel.

Also: This isn't a mac80211 patch. Please name patches after the
subsystem that gets new API, not after the subsystem that implements it
-- a simple implementation is fine in the same patch, a more complex one
might warrant a separate patch.

johannes

