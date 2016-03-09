Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48627 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbcCILSb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 06:18:31 -0500
Message-ID: <1457522305.2042.3.camel@sipsolutions.net> (sfid-20160309_122230_157004_2105DE3D)
Subject: Re: [PATCH v2] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Date: Wed, 09 Mar 2016 12:18:25 +0100
In-Reply-To: <20160309105231.GA7145@atheros-ThinkPad-T61>
References: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1457515803.2042.1.camel@sipsolutions.net>
	 <20160309093845.GA6695@atheros-ThinkPad-T61>
	 <1457517488.2042.2.camel@sipsolutions.net>
	 <20160309105231.GA7145@atheros-ThinkPad-T61>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 16:22 +0530, Mohammed Shafi Shajakhan wrote:
> 
> [shafi] ath10k implementation is based on PPDU duration calculation
> and it does not includes any IFS duration.
> 
> So 'Energy' (time spent by the radio on receiving frames from a
> particular peer) makes more sense right ?
> 

Fine with me, perhaps just saying "aggregate PPDU duration" would be a
good thing?

johannes
