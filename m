Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55423 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab0CYGq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 02:46:29 -0400
Subject: Re: [PATCH 0/2] mac80211: cfg80211: Roam trigger support
From: Johannes Berg <johannes@sipsolutions.net>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	luciano.coelho@nokia.com
In-Reply-To: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1269327754-995-1-git-send-email-juuso.oikarinen@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 23:46:07 -0700
Message-ID: <1269499567.5041.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-23 at 09:02 +0200, Juuso Oikarinen wrote:
> To implement good performance WLAN roaming, it is not sufficient to start
> scanning for other available AP's only after the currently serving association
> is lost.
> 
> The entity controlling the roaming will need to get indication of a
> deteriorating WLAN connection in order to start preparing for roaming already
> before the serving association is lost. This way, it can roam to a better AP
> perhaps even before the serving association becomes too bad in quality.
> 
> These patches propose an implementation facilitating this using a simple RSSI
> threshold and hysteresis approach.

So this is merged, anyone want to implement it in mac80211 so we can
start playing with it? I won't get around to it for quite a while.

johannes

