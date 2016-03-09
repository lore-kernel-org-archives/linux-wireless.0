Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48063 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbcCIJ6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:58:11 -0500
Message-ID: <1457517488.2042.2.camel@sipsolutions.net> (sfid-20160309_105817_511571_A39ED6F2)
Subject: Re: [PATCH v2] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Date: Wed, 09 Mar 2016 10:58:08 +0100
In-Reply-To: <20160309093845.GA6695@atheros-ThinkPad-T61>
References: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1457515803.2042.1.camel@sipsolutions.net>
	 <20160309093845.GA6695@atheros-ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 15:08 +0530, Mohammed Shafi Shajakhan wrote:

> [shafi] Please suggest if this is ok ? I will be thankful
> if you can suggest a better one if this is not ok
> 
> * @rx_duration: approximate total air time(usecs) for all the
>  frames from a peer
> 

That seems fine. We should perhaps specify the meaning of "air time"
though. Is it allocated NAV time, or is it just time in which there was
energy? With or without any IFS?

johannes
