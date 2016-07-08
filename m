Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54375 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbcGHKeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:34:03 -0400
Message-ID: <1467974039.4837.4.camel@sipsolutions.net> (sfid-20160708_123411_168155_CCB0458B)
Subject: Re: [PATCH] cfg80211: Add support for user configurable beacon data
 rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Purushottam Kushwaha <pkushwah@qti.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, jouni@qca.qualcomm.com,
	usdutt@qti.qualcomm.com, ganeshk@qti.qualcomm.com,
	mkalikot@qca.qualcomm.com, amarnath@qca.qualcomm.com
Date: Fri, 08 Jul 2016 12:33:59 +0200
In-Reply-To: <1467973690-32120-1-git-send-email-pkushwah@qti.qualcomm.com> (sfid-20160708_122844_220402_00258612)
References: <1467973690-32120-1-git-send-email-pkushwah@qti.qualcomm.com>
	 (sfid-20160708_122844_220402_00258612)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-08 at 15:58 +0530, Purushottam Kushwaha wrote:
> 
>   *
> + * @NL80211_ATTR_BEACON_TXRATE: User configurable beacon data rate
> (u32). This is
> + *	used to set beacon tx rate.
> 
It seems this should be nested from enum nl80211_tx_rate_attributes, to
perhaps allow HT/VHT beacons in the future.

johannes
