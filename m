Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46570 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbcCIJaH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:30:07 -0500
Message-ID: <1457515803.2042.1.camel@sipsolutions.net> (sfid-20160309_103010_518752_F70ABD42)
Subject: Re: [PATCH v2] cfg80211/nl80211: Add support for
 NL80211_STA_INFO_RX_DURATION
From: Johannes Berg <johannes@sipsolutions.net>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>,
	linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, kvalo@codeaurora.org,
	mohammed@codeaurora.org
Date: Wed, 09 Mar 2016 10:30:03 +0100
In-Reply-To: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1457508003-16700-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 12:50 +0530, Mohammed Shafi Shajakhan wrote:
> 
> + * @rx_duration: approximate total air time(usecs) for all the
> frames from a
> + *	connected client

I don't see why this should be restricted to "connected clients". The
same value could be used for a mesh peer. Or TDLS peer. Or the AP on a
managed connection. Or all the other types of STA.

johannes
