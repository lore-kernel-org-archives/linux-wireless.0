Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56384 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753954AbcCCPAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:00:14 -0500
Message-ID: <1457017211.2044.14.camel@sipsolutions.net> (sfid-20160303_160030_116392_821475FD)
Subject: Re: [PATCH] mac80211: do not pass injected frames without a valid
 rate to the driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: sven@narfation.org
Date: Thu, 03 Mar 2016 16:00:11 +0100
In-Reply-To: <1456930491-17495-1-git-send-email-nbd@openwrt.org>
References: <1456930491-17495-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 15:54 +0100, Felix Fietkau wrote:
> Fall back to rate control if the requested bitrate was not found.
> 
Applied, thakns.

johannes
