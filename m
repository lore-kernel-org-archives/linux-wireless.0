Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:6197 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbbDIMLQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 08:11:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH 3/4] ath10k: Fix no-ack frame status
References: <1418226973-13779-1-git-send-email-sujith@msujith.org>
	<1418226973-13779-3-git-send-email-sujith@msujith.org>
Date: Thu, 9 Apr 2015 15:11:09 +0300
In-Reply-To: <1418226973-13779-3-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Wed, 10 Dec 2014 21:26:12 +0530")
Message-ID: <87lhi1ec2q.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_141120_141460_550909FF)
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

Thanks, applied.

-- 
Kalle Valo
