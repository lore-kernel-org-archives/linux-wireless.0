Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44492 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbcCIGjb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 01:39:31 -0500
Date: Wed, 9 Mar 2016 12:09:15 +0530
From: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	kvalo@codeaurora.org
Subject: Re: [PATCH v1] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
Message-ID: <20160309063914.GA6068@atheros-ThinkPad-T61> (sfid-20160309_073935_037699_7A21F8D2)
References: <1457348614-10584-1-git-send-email-mohammed@qca.qualcomm.com>
 <1457455943.24270.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1457455943.24270.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Tue, Mar 08, 2016 at 05:52:23PM +0100, Johannes Berg wrote:
> On Mon, 2016-03-07 at 16:33 +0530, Mohammed Shafi Shajakhan wrote:
> > From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > 
> > Add support for new netlink attribute 'NL80211_STA_INFO_RX_DURATION'
> > This flag will be set when drivers can fill rx_duration (vendor
> > specific total air time(usecs) for data/management frames from the
> > connected client) via 'drv_sta_statistics' callback
> > 
> > Also make sta_info flags 'filled' as 64 bit to accommodate for new
> > per station stats. Extend 'PUT_SINFO' for supporting rx_duration
> > field and any new per sta information in future
> > 
> > Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> > ---
> > [v1] 
> > 1. Fixed typo for accommodate
> > 2. changed the doc for rx_duration as 'vendor specific
> > implementation'
> 
> No, I want it defined for all cases, not left undefined.

[shafi] Let me know if the below documentation is fine with you please

"@rx_duration: approximate total air time(usecs) for all data/management
    frames from the connected client "

thanks for reviewing this and Jouni for his initial suggestions.

regards,
shafi

