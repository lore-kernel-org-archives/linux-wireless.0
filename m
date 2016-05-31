Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58134 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436AbcEaNZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 09:25:50 -0400
Date: Tue, 31 May 2016 18:55:38 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] iw: Add support for NL80211_STA_INFO_RX_DURATION
 netlink attribute
Message-ID: <20160531132538.GA3146@atheros-ThinkPad-T61> (sfid-20160531_152554_868925_EBABC2D6)
References: <1460039420-5418-1-git-send-email-mohammed@qti.qualcomm.com>
 <1464687668.3076.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1464687668.3076.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 31, 2016 at 11:41:08AM +0200, Johannes Berg wrote:
> On Thu, 2016-04-07 at 20:00 +0530, Mohammed Shafi Shajakhan wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'.
> > 'NL80211_STA_INFO_RX_DURATION' accounts for aggregate PPDU duration
> > in microseconds for all the frames from a peer. Drivers can fill
> > 'rx_duration' field and set the flag 'NL80211_STA_INFO_RX_DURATION'.
> > 'rx_duration' will give an idea about the total time spent by our
> > peer
> > with each of its connected peers.
> > 
> > This will get dumped as part of 'iw dev wlan#N station dump'
> > 
> Applied.
> 
> It's easier for me if you don't send nl80211.h changes in iw patches,
> but I can deal with just removing those too.

[shafi] sure Johannes, next time i will sending nl80211.h changes

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
