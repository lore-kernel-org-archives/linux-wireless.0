Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:36934 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbcA2ML0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2016 07:11:26 -0500
Subject: Re: [PATCH] mac80211: minstrel_ht: fix out-of-bound in
 minstrel_ht_set_best_prob_rate
To: Konstantin Khlebnikov <koct9i@gmail.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <145405651192.4948.10685647900939287282.stgit@zurg>
Cc: netdev@vger.kernel.org,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56AB56E7.4090705@openwrt.org> (sfid-20160129_131155_852902_47264967)
Date: Fri, 29 Jan 2016 13:11:19 +0100
MIME-Version: 1.0
In-Reply-To: <145405651192.4948.10685647900939287282.stgit@zurg>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-01-29 09:35, Konstantin Khlebnikov wrote:
> Patch fixes this splat
> 
> BUG: KASAN: slab-out-of-bounds in minstrel_ht_update_stats.isra.7+0x6e1/0x9e0
> [mac80211] at addr ffff8800cee640f4 Read of size 4 by task swapper/3/0
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Link: http://lkml.kernel.org/r/CALYGNiNyJhSaVnE35qS6UCGaSb2Dx1_i5HcRavuOX14oTz2P+w@mail.gmail.com
Acked-by: Felix Fietkau <nbd@openwrt.org>
