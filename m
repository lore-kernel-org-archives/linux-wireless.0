Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:43473 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbZAEQ5P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 11:57:15 -0500
Date: Mon, 5 Jan 2009 18:11:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Andi Kleen <andi@firstfloor.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
Message-ID: <20090105171105.GW496@one.firstfloor.org> (sfid-20090105_175717_665390_9D97C75C)
References: <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org> <20090105152410.GT496@one.firstfloor.org> <49622686.9050005@openwrt.org> <20090105163553.GU496@one.firstfloor.org> <49623712.4060106@openwrt.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49623712.4060106@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> According to the rate control's view, only the 1M has a usable
> success probability. It's rather insteresting that 11M is the only
> other rate that had some successes. With this kind of results, the
> only two options that I can think of are either a systematic tx
> status reporting error (false negative for the IEEE80211_TX_STAT_ACK
> flag), or something PHY related.

Ok. Any more data I should provide to help tracking this down?
Do you want the same from the RaLink?

-Andi
-- 
ak@linux.intel.com
