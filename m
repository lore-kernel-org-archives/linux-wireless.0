Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:64411 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965778AbbDVJBJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2015 05:01:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 07/11] ath10k: enable IEEE80211_HW_SUPPORT_FAST_XMIT
In-Reply-To: <1429283751-5104-7-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Fri, 17 Apr 2015 17:15:47 +0200")
References: <1429283751-5104-1-git-send-email-johannes@sipsolutions.net>
	<1429283751-5104-7-git-send-email-johannes@sipsolutions.net>
Date: Wed, 22 Apr 2015 12:00:39 +0300
Message-ID: <87h9s8y1u0.fsf@kamboji.qca.qualcomm.com> (sfid-20150422_110116_574388_18C9F0F1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> From: Johannes Berg <johannes.berg@intel.com>
>
> The driver can clearly enable fast-xmit since it does rate
> control in the device and thus must do duration calculation
> there as well.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

I quickly tested mac80211-next/fast-xmit (commit cf9f262fdd3f) with
ath10k and didn't see any problems so:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
