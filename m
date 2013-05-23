Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35900 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab3EWUJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 16:09:09 -0400
Message-ID: <1369339742.12002.42.camel@jlt4.sipsolutions.net> (sfid-20130523_220913_771290_E7690F4A)
Subject: Re: [PATCH 3.10] cfg80211: fix reporting 64-bit station info tx
 bytes
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 23 May 2013 22:09:02 +0200
In-Reply-To: <1369314359-99291-1-git-send-email-nbd@openwrt.org>
References: <1369314359-99291-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 15:05 +0200, Felix Fietkau wrote:
> Copy & paste mistake - STATION_INFO_TX_BYTES64 is the name of the flag,
> not NL80211_STA_INFO_TX_BYTES64.

Applied, thanks.

johannes

