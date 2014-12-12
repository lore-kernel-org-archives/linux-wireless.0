Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33262 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967378AbaLLMsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:48:42 -0500
Message-ID: <1418388519.2470.38.camel@sipsolutions.net> (sfid-20141212_134846_280880_8B35C094)
Subject: Re: [PATCH 2/4] mac80211: Fix accounting of multicast frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Sujith Manoharan <sujith@msujith.org>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Dec 2014 13:48:39 +0100
In-Reply-To: <1418226973-13779-2-git-send-email-sujith@msujith.org>
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
	 <1418226973-13779-2-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-12-10 at 21:26 +0530, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> Since multicast frames are marked as no-ack, using
> IEEE80211_TX_STAT_ACK to check if they have been
> successfully transmitted by the driver is incorrect
> since a driver can choose to ignore transmission status
> for no-ack frames. This results in incorrect accounting
> for such frames.
> 
> To fix this issue, this patch introduces a new flag
> that can be used by drivers to indicate error-free
> transmission of no-ack frames.

Seems fine, applied. I've worded the documentation a bit more strongly.

johannes

