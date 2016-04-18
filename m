Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52649 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbcDRHVx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 03:21:53 -0400
Date: Mon, 18 Apr 2016 12:51:42 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160418072046.GA2634@atheros-ThinkPad-T61> (sfid-20160418_092156_515593_4D656034)
References: <1460039374-5338-1-git-send-email-mohammed@qti.qualcomm.com>
 <1460624376.2358.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460624376.2358.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 14, 2016 at 10:59:36AM +0200, Johannes Berg wrote:
> On Thu, 2016-04-07 at 19:59 +0530, Mohammed Shafi Shajakhan wrote:
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
> > Also extend 'PUT_SINFO' for supporting rx_duration field
> > 
> Applied, with some minor changes.
>
[shafi] thank you for accepting this change Johannes.

regards,
shafi
