Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [78.193.33.39] ([78.193.33.39]:39988 "EHLO qult.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab3BUCdt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 21:33:49 -0500
Date: Thu, 21 Feb 2013 03:08:06 +0100
From: Ignacy Gawedzki <i@lri.fr>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] iwlwifi: Move updating of bssid under the
 association_changed flag to avoid crash
Message-ID: <20130221020806.GA8878@zenon.in.qult.net> (sfid-20130221_033355_634886_FFF34D5C)
References: <CABPxzY+g1gZGmXA=RuoXZY4LFXwkYN8VWKowr-oN_q3mad0w3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABPxzY+g1gZGmXA=RuoXZY4LFXwkYN8VWKowr-oN_q3mad0w3w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 13, 2013 at 02:56:51AM +0530, thus spake Krishna Chaitanya:
> BSSID from the BSS conf should be updated only when
> there is a change in association information.
> 
> This was causing the crash in latest mac80211-next
> when bringing the interface in monitor mode.
> (Basically changing the bss_info).
> 
> Signed-off-by: Chaitanya <chaitanya.mgit@gmail.com>
> ---
> Note1: Will fix the styling issues while submitting the patch.
> Note2: For monitor mode the flag BSS_CHANGED_ASSOC
> is not set.So its causing the crash.

I'd like to confirm that I had the same problem until I applied this patch.

-- 
NO CARRIER
