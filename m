Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34424 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751773AbdFTVJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2017 17:09:54 -0400
Message-ID: <1497992992.11421.3.camel@sipsolutions.net> (sfid-20170620_230958_118791_62EA1EED)
Subject: Re: [RFC] mac80211: support non-data TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: nbd@nbd.name
Date: Tue, 20 Jun 2017 23:09:52 +0200
In-Reply-To: <20170620210309.1193-1-johannes@sipsolutions.net> (sfid-20170620_230321_402397_A3FCC329)
References: <20170620210309.1193-1-johannes@sipsolutions.net>
         (sfid-20170620_230321_402397_A3FCC329)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-06-20 at 23:03 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some drivers may want to also use the TXQ abstraction with
> non-data packets, so add a hardware flag to allow this.

Need to replace various ARRAY_SIZE(sta->txq) in ath9k/ath10k by
IEEE80211_NUM_TIDS.

johannes
