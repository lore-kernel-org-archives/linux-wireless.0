Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49179 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964925Ab3DRMkV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 08:40:21 -0400
Message-ID: <516FE9B1.3000106@openwrt.org> (sfid-20130418_144027_116425_2BA55CAD)
Date: Thu, 18 Apr 2013 14:40:17 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH 1/2] mac80211: minstrel_ht: pick only supported rates
 for sta and group max*rates
References: <1366287883-24054-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1366287883-24054-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-04-18 2:24 PM, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> minstrel_ht initializes max_tp_rate max_tp_rate2 and max_prob_rate to
> zero both for minstrel_ht_sta and minstrel_mcs_group_data.
> This is wrong since there is no guarantee that the 1st rate of any
> group is supported.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
For both patches,
Acked-by: Felix Fietkau <nbd@openwrt.org>
