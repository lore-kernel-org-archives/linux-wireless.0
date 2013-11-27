Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22707 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0PE2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 10:04:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] ath10k: fixes 2013-11-22
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 27 Nov 2013 17:04:22 +0200
In-Reply-To: <1385474260-22385-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Tue, 26 Nov 2013 14:57:37 +0100")
Message-ID: <87haaxga2x.fsf@kamboji.qca.qualcomm.com> (sfid-20131127_160431_317269_45047D32)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This has some fixes I've stacked in my local repo.
> There are no dependencies between them.
>
> v2:
>  * refined commit messages
>
> Michal Kazior (3):
>   ath10k: use nss provided by mac80211

Dropped by your request.

>   ath10k: implement sta_rc_update()

I had comments for this.

>   ath10k: fix Tx status clearing

This is applied.

-- 
Kalle Valo
