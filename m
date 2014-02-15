Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40040 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaBOSN5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Feb 2014 13:13:57 -0500
Message-ID: <1392488030.4298.5.camel@jlt4.sipsolutions.net> (sfid-20140215_191420_606113_F54FF2B5)
Subject: Re: [PATCH] Drivers: net: wireless: mac80211_hwim fixed coding
 style issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Justin van Wijngaarden <justinvanwijngaarden@gmail.com>
Cc: linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Sat, 15 Feb 2014 19:13:50 +0100
In-Reply-To: <1392465312-3780-1-git-send-email-justinvanwijngaarden@gmail.com> (sfid-20140215_125633_755512_88424C91)
References: <1392465312-3780-1-git-send-email-justinvanwijngaarden@gmail.com>
	 (sfid-20140215_125633_755512_88424C91)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-02-15 at 12:55 +0100, Justin van Wijngaarden wrote:

> @@ -1,19 +1,17 @@
> -/*
> - * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
> +/* mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211

I don't see any point in this - lots of code exists both ways, that's
really just fluff. The difference isn't even interesting enough to be
worth fixing up.

>   * published by the Free Software Foundation.
> - */
> +*/

That's just wrong.

In any case, your patch won't apply anyway since we've since
changed/removed code that you're modifying.

There's very little in this patch that I'd be willing to apply, and most
of that you actually got the coding style wrong so it's not an
improvement at all.

johannes

