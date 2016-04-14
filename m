Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42427 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbcDNI7k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 04:59:40 -0400
Message-ID: <1460624376.2358.8.camel@sipsolutions.net> (sfid-20160414_105945_314826_DD3B91F3)
Subject: Re: [PATCH v4] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 14 Apr 2016 10:59:36 +0200
In-Reply-To: <1460039374-5338-1-git-send-email-mohammed@qti.qualcomm.com>
References: <1460039374-5338-1-git-send-email-mohammed@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-04-07 at 19:59 +0530, Mohammed Shafi Shajakhan wrote:
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
> Also extend 'PUT_SINFO' for supporting rx_duration field
> 
Applied, with some minor changes.

johannes
