Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:34869 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760712AbcINLHH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 07:07:07 -0400
Subject: Re: [PATCH v3] mac80211: check skb_linearize() return value
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1473847726-29223-1-git-send-email-johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <e824c071-5b6b-8382-0b61-91e19d1bc679@nbd.name> (sfid-20160914_130715_416771_9C3CA4E6)
Date: Wed, 14 Sep 2016 13:06:25 +0200
MIME-Version: 1.0
In-Reply-To: <1473847726-29223-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-09-14 12:08, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The A-MSDU TX code (within TXQs) didn't always check the return value
> of skb_linearize() properly, resulting in potentially passing a frag-
> list SKB down to the driver even when it said it can't handle it. Fix
> that.
> 
> Fixes: 6e0456b545456 ("mac80211: add A-MSDU tx support")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
