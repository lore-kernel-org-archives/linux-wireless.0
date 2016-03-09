Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59204 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbcCIKwq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 05:52:46 -0500
Date: Wed, 9 Mar 2016 16:22:31 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH v2] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160309105231.GA7145@atheros-ThinkPad-T61> (sfid-20160309_115250_437302_7FE7EBA1)
References: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457515803.2042.1.camel@sipsolutions.net>
 <20160309093845.GA6695@atheros-ThinkPad-T61>
 <1457517488.2042.2.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457517488.2042.2.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,


On Wed, Mar 09, 2016 at 10:58:08AM +0100, Johannes Berg wrote:
> On Wed, 2016-03-09 at 15:08 +0530, Mohammed Shafi Shajakhan wrote:
> 
> > [shafi] Please suggest if this is ok ? I will be thankful
> > if you can suggest a better one if this is not ok
> > 
> > * @rx_duration: approximate total air time(usecs) for all the
> >  frames from a peer
> > 
> 
> That seems fine. We should perhaps specify the meaning of "air time"
> though. Is it allocated NAV time, or is it just time in which there was
> energy? With or without any IFS?
>

[shafi] ath10k implementation is based on PPDU duration calculation
and it does not includes any IFS duration.

So 'Energy' (time spent by the radio on receiving frames from a particular
peer) makes more sense right ?

regards,
shafi
