Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60914 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755466AbcBBOzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 09:55:23 -0500
Message-ID: <1454424920.2926.2.camel@sipsolutions.net> (sfid-20160202_155530_810237_73222319)
Subject: Re: [PATCH] mac80211: minstrel_ht: fix out-of-bound in
 minstrel_ht_set_best_prob_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Konstantin Khlebnikov <koct9i@gmail.com>,
	Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org,
	Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Date: Tue, 02 Feb 2016 15:55:20 +0100
In-Reply-To: <145405651192.4948.10685647900939287282.stgit@zurg> (sfid-20160129_093515_897484_5ED72DF7)
References: <145405651192.4948.10685647900939287282.stgit@zurg>
	 (sfid-20160129_093515_897484_5ED72DF7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-01-29 at 11:35 +0300, Konstantin Khlebnikov wrote:
> Patch fixes this splat
> 
> BUG: KASAN: slab-out-of-bounds in
> minstrel_ht_update_stats.isra.7+0x6e1/0x9e0
> [mac80211] at addr ffff8800cee640f4 Read of size 4 by task
> swapper/3/0
> 
> Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
> Link: http://lkml.kernel.org/r/CALYGNiNyJhSaVnE35qS6UCGaSb2Dx1_i5HcRa
> vuOX14oTz2P+w@mail.gmail.com
> 

Applied, thanks.

johannes
