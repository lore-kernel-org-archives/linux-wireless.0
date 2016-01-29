Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60045 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbcA2IdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 03:33:18 -0500
Message-ID: <1454056380.3369.2.camel@sipsolutions.net> (sfid-20160129_093326_043696_6A73B908)
Subject: Re: WARNING at net/mac80211/rate.c:513 ieee80211_get_tx_rates
 [mac80211]
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	David Miller <davem@davemloft.net>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Date: Fri, 29 Jan 2016 09:33:00 +0100
In-Reply-To: <56AAC66C.1080800@lwfinger.net> (sfid-20160129_025456_485103_1633A2EE)
References: <CA+55aFxe22iWok6UojY=hCoG2k1wNpJ9CfQ0b+STSxq67tb86Q@mail.gmail.com>
	 <1453983185.2217.12.camel@sipsolutions.net>
	 <CA+55aFya9K4JboNY8kB9cg6zt9otguhdzfHm3jvLmWedxQTSWg@mail.gmail.com>
	 <1454013625.2332.9.camel@sipsolutions.net>
	 <CA+55aFx73nv9ny-fu5BR6v8wL=f2oFomwrZoLRw=x2kNP76cYA@mail.gmail.com>
	 <CA+55aFzF0gWfvmE+6ZcHmjnO4xp-oVAQ5SWxYJhOzns2ocgCsw@mail.gmail.com>
	 <1454019155.2332.15.camel@sipsolutions.net>
	 <CA+55aFxjpdepHYD_6uU48kW38Z9bmf2wwA8yPZt4ibhkofmfQA@mail.gmail.com>
	 <56AAC66C.1080800@lwfinger.net> (sfid-20160129_025456_485103_1633A2EE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-28 at 19:54 -0600, Larry Finger wrote:
> 
> I have been running an RTL8821AE since kernel 3.18 without hitting
> this problem 
> using a TRENDnet AC1750 dual-band AP. The UniFi may be doing
> something that the 
> driver is not expecting.

Are you quite sure you're actually using VHT though, perhaps the AP
somehow turned it off? It seems unlikely that you could successfully
use it in any way given that RATE_INFO_FLAGS_VHT_MCS doesn't show up in
the driver or rate scaling at all.


johannes
