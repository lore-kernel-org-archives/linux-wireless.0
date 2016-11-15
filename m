Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48794 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932110AbcKONc5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 08:32:57 -0500
Message-ID: <1479216773.12007.28.camel@sipsolutions.net> (sfid-20161115_143300_474514_5B9A2783)
Subject: Re: [PATCH] Revert "mac80211: allow using AP_LINK_PS with
 mac80211-generated TIM IE"
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Cc: emmanuel.grumbach@intel.com
Date: Tue, 15 Nov 2016 14:32:53 +0100
In-Reply-To: <20161103111247.18086-1-nbd@nbd.name>
References: <20161103111247.18086-1-nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-03 at 12:12 +0100, Felix Fietkau wrote:
> This reverts commit c68df2e7be0c1238ea3c281fd744a204ef3b15a0.
> 
> __sta_info_recalc_tim turns into a no-op if local->ops->set_tim is
> not
> set. This prevents the beacon TIM bit from being set for all drivers
> that do not implement this op (almost all of them), thus thoroughly
> essential AP mode powersave functionality.
> 
Applied.

johannes
