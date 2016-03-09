Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51612 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbcCIJjL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:39:11 -0500
Date: Wed, 9 Mar 2016 15:08:45 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH v2] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160309093845.GA6695@atheros-ThinkPad-T61> (sfid-20160309_103915_949953_FE204764)
References: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457515803.2042.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457515803.2042.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 09, 2016 at 10:30:03AM +0100, Johannes Berg wrote:
> On Wed, 2016-03-09 at 12:50 +0530, Mohammed Shafi Shajakhan wrote:
> > 
> > + * @rx_duration: approximate total air time(usecs) for all the
> > frames from a
> > + *	connected client
> 
> I don't see why this should be restricted to "connected clients". The
> same value could be used for a mesh peer. Or TDLS peer. Or the AP on a
> managed connection. Or all the other types of STA.

[shafi] Please suggest if this is ok ? I will be thankful
if you can suggest a better one if this is not ok

* @rx_duration: approximate total air time(usecs) for all the
 frames from a peer

 regards,
 shafi

