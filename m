Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36815 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbbDIL7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Apr 2015 07:59:00 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: replenish htc tx credits always
References: <1427368943-29526-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 9 Apr 2015 14:58:54 +0300
In-Reply-To: <1427368943-29526-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 26 Mar 2015 11:22:23 +0000")
Message-ID: <874mopfr7l.fsf@kamboji.qca.qualcomm.com> (sfid-20150409_135906_802108_08C7754F)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> There's always at most 2 credits and it makes
> little sense to set the
> ATH10K_HTC_FLAG_NEED_CREDIT_UPDATE flag
> conditionally.
>
> This seems to fix some random issues with tx
> credit starvation on WLAN.RM.2.0-00073 I've been
> seeing. Note: this isn't related to wmi mgmt tx.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
