Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49714 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609AbaLKKK6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2014 05:10:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Sujith Manoharan <sujith@msujith.org>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/4] ath10k: Fix no-ack frame status
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
	<1418226973-13779-3-git-send-email-sujith@msujith.org>
Date: Thu, 11 Dec 2014 12:10:39 +0200
In-Reply-To: <1418226973-13779-3-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Wed, 10 Dec 2014 21:26:12 +0530")
Message-ID: <87oarazecg.fsf@kamboji.qca.qualcomm.com> (sfid-20141211_111106_498830_ABE8173A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> Use the new IEEE80211_TX_STAT_NOACK_TRANSMITTED flag
> to indicate successful transmission of no-ack frames.
> This fixes multicast frame accounting.
>
> Cc: ath10k@lists.infradead.org
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Johannes, are you planning to take this? Or should I take this once the
corresponding mac80211 patch trickles down to my tree?

-- 
Kalle Valo
