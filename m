Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39247 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755658Ab3H3L3x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Aug 2013 07:29:53 -0400
Message-ID: <1377862182.16256.5.camel@jlt4.sipsolutions.net> (sfid-20130830_132957_667874_8896B16F)
Subject: Re: [PATCH 0/2] mac80211: fix minstrel fixed_rate management
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 30 Aug 2013 13:29:42 +0200
In-Reply-To: <52207CC4.50702@openwrt.org>
References: <1377615587-6015-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <52207CC4.50702@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-30 at 13:06 +0200, Felix Fietkau wrote:
> On 2013-08-27 4:59 PM, Lorenzo Bianconi wrote:
> > This couple of patches add/fix fixed_rate management of minstrel/minstrel_ht
> > rate controller. In particular:
> > *[PATCH 1/2]: add the capability to use a particular rate to minstrel rate
> >  controller
> > *[PATCH 2/2]: restore the mcs index configured according to fixed_rate value
> >  since it has been overridden in minstrel_ht_update_stats throughput computation
> > 
> > Regards,
> > Lorenzo
> > 
> > Lorenzo Bianconi (2):
> >   mac80211: add fixed_rate management to minstrel rc
> >   mac80211: do not override fixed_rate_idx in minstrel_ht_update_stats
> > 
> >  net/mac80211/rc80211_minstrel.c    | 14 ++++++++++++++
> >  net/mac80211/rc80211_minstrel_ht.c | 23 +++++++++++++----------
> >  2 files changed, 27 insertions(+), 10 deletions(-)
> Acked-by: Felix Fietkau <nbd@openwrt.org>

Applied.

johannes

