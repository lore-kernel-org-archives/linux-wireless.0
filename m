Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46794 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751319AbdKPHNQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Nov 2017 02:13:16 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Weixiao Zhang <waveletboy@gmail.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mac80211: mwl8k: Expand non-DFS 5G channels
References: <20171116031422.5408-1-waveletboy@gmail.com>
Date: Thu, 16 Nov 2017 09:13:10 +0200
In-Reply-To: <20171116031422.5408-1-waveletboy@gmail.com> (Weixiao Zhang's
        message of "Wed, 15 Nov 2017 21:14:22 -0600")
Message-ID: <87lgj67l2x.fsf@codeaurora.org> (sfid-20171116_081844_615194_09F8AB43)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Weixiao Zhang <waveletboy@gmail.com> writes:

> Signed-off-by: Weixiao Zhang <waveletboy@gmail.com>

No empty commit logs, please.

And use v2, v3 to clearly mark what's the version of the patch:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#patch_version_missing

>  drivers/net/wireless/marvell/mwl8k.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

You should use "mac80211:" prefix only with patches touching
net/mac80211. So for this one "mwl8k:" is enough.

-- 
Kalle Valo
