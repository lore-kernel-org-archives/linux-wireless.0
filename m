Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43391 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3H3LG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 07:06:56 -0400
Message-ID: <52207CC4.50702@openwrt.org> (sfid-20130830_130659_129121_F182A28A)
Date: Fri, 30 Aug 2013 13:06:44 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 0/2] mac80211: fix minstrel fixed_rate management
References: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
In-Reply-To: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-08-27 4:59 PM, Lorenzo Bianconi wrote:
> This couple of patches add/fix fixed_rate management of minstrel/minstrel_ht
> rate controller. In particular:
> *[PATCH 1/2]: add the capability to use a particular rate to minstrel rate
>  controller
> *[PATCH 2/2]: restore the mcs index configured according to fixed_rate value
>  since it has been overridden in minstrel_ht_update_stats throughput computation
> 
> Regards,
> Lorenzo
> 
> Lorenzo Bianconi (2):
>   mac80211: add fixed_rate management to minstrel rc
>   mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats
> 
>  net/mac80211/rc80211_minstrel.c    | 14 ++++++++++++++
>  net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++----------
>  2 files changed, 27 insertions(+), 10 deletions(-)
Acked-by: Felix Fietkau <nbd@openwrt.org>

