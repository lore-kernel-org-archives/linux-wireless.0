Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40372 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756909AbcEaJlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 05:41:11 -0400
Message-ID: <1464687668.3076.1.camel@sipsolutions.net> (sfid-20160531_114115_412823_37B92827)
Subject: Re: [PATCH v4] iw: Add support for NL80211_STA_INFO_RX_DURATION
 netlink attribute
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 31 May 2016 11:41:08 +0200
In-Reply-To: <1460039420-5418-1-git-send-email-mohammed@qti.qualcomm.com>
References: <1460039420-5418-1-git-send-email-mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-07 at 20:00 +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'.
> 'NL80211_STA_INFO_RX_DURATION' accounts for aggregate PPDU duration
> in microseconds for all the frames from a peer. Drivers can fill
> 'rx_duration' field and set the flag 'NL80211_STA_INFO_RX_DURATION'.
> 'rx_duration' will give an idea about the total time spent by our
> peer
> with each of its connected peers.
> 
> This will get dumped as part of 'iw dev wlan#N station dump'
> 
Applied.

It's easier for me if you don't send nl80211.h changes in iw patches,
but I can deal with just removing those too.

johannes
