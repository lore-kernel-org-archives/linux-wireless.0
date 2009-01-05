Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:55753 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751231AbZAERBj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 12:01:39 -0500
Message-ID: <49623CEA.4080407@openwrt.org> (sfid-20090105_180141_565079_86C6F679)
Date: Mon, 05 Jan 2009 18:01:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Larry Finger <Larry.Finger@lwfinger.net>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: rate instability in wireless stack
References: <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org> <49620BE5.9030507@openwrt.org> <20090105142343.GS496@one.firstfloor.org> <49621C36.70602@openwrt.org> <20090105152410.GT496@one.firstfloor.org> <49622686.9050005@openwrt.org> <20090105163553.GU496@one.firstfloor.org> <49623712.4060106@openwrt.org> <20090105171105.GW496@one.firstfloor.org>
In-Reply-To: <20090105171105.GW496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
>> According to the rate control's view, only the 1M has a usable
>> success probability. It's rather insteresting that 11M is the only
>> other rate that had some successes. With this kind of results, the
>> only two options that I can think of are either a systematic tx
>> status reporting error (false negative for the IEEE80211_TX_STAT_ACK
>> flag), or something PHY related.
> 
> Ok. Any more data I should provide to help tracking this down?
> Do you want the same from the RaLink?
Yes, It'd be interesting to see if the table looks similar or if
more rates work.

- Felix
