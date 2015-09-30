Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bluebottle.com ([176.9.67.91]:58446 "EHLO
	mail.bluebottle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbbI3Re1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 13:34:27 -0400
Date: Wed, 30 Sep 2015 19:33:09 +0200
From: Bastian Bittorf <bittorf@bluebottle.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Johannes Berg <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, mcgrof@do-not-panic.com,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org
Subject: Re: Low latency communication over wifi
Message-ID: <20150930173309.GX22537@medion.lan> (sfid-20150930_193430_412259_51672AE6)
References: <20150926102403.GA21555@amd>
 <1443426103.2401.1.camel@sipsolutions.net>
 <20150930172440.GA11160@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150930172440.GA11160@amd>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Pavel Machek <pavel@ucw.cz> [30.09.2015 19:27]:
> This should send the second  ping to the priority queue based on -Q,
> but I don't see an effect against one access point.... and it seems to
> work somehow against second one. Good!

you still need to hack/tune minstrel, because a lot of magic is
happen there including rts/cts on/off switching. a starting point is
e.g. this:
https://github.com/steinwurf/openwrt-patches/blob/master/openwrt-r41097/mac80211/910-minstrel-retry-limit.patch

bye, bastian
