Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33248 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967013AbaLLMp2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:45:28 -0500
Message-ID: <1418388320.2470.36.camel@sipsolutions.net> (sfid-20141212_134531_785154_CC321668)
Subject: Re: [PATCH 1/4] mac80211: Move IEEE80211_TX_CTL_PS_RESPONSE
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 13:45:20 +0100
In-Reply-To: <1418226973-13779-1-git-send-email-sujith@msujith.org>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 21:26 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Move IEEE80211_TX_CTL_PS_RESPONSE to info->control.flags since
> this is used only in the TX path (by ath9k). This frees up
> a bit which can be used for other purposes.

Applied.

johannes

