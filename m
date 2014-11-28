Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41298 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbaK1NXp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 08:23:45 -0500
Message-ID: <1417181014.27562.4.camel@sipsolutions.net> (sfid-20141128_142348_958914_B6A45827)
Subject: Re: [PATCH] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org
Date: Fri, 28 Nov 2014 14:23:34 +0100
In-Reply-To: <CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com> (sfid-20141127_160027_454217_BB20D2B6)
References: <1417095547-12197-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1417099707.19919.0.camel@sipsolutions.net>
	 <CAA2SeNJuMYXRAU3NFABsKk27_ojZARBByRx4oU3xApaDnBJYug@mail.gmail.com>
	 (sfid-20141127_160027_454217_BB20D2B6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I would like to enable TPC in ath9k using iw command:
> 
> iw dev wlan0 set txpower auto
> 
> I knew user_power_level is set to IEEE80211_UNSET_POWER_LEVEL in that
> case. Is there a better way than to check user_power_level?

But ... the API already allows for that flexibility? I think if anything
you should expose the "TX power type" that the nl80211 API has.

johannes

