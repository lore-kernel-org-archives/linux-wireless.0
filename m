Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:47421 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbbCWPMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2015 11:12:08 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: fix rts profile for second rate series
References: <1425451847-14505-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 23 Mar 2015 17:11:52 +0200
In-Reply-To: <1425451847-14505-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 4 Mar 2015 12:20:46 +0530")
Message-ID: <87bnjjeojr.fsf@kamboji.qca.qualcomm.com> (sfid-20150323_161212_693475_52FF4642)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> By default rts protection is enabled in firmware for the second
> rateset. Currently ath10k selects RTS profile (only for software
> retries), when legacy stations are associated or asked by mac80211.
> On congested environment, when AP is running in HT/VHT mode and
> there are no legacy clients associated, this will impact the
> robustness. Also enabling RTS protection only for second rateset will
> not impact performance on clear environment. Fix that.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

Thanks, both patches applied.

-- 
Kalle Valo
