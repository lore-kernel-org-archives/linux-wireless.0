Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650AbbHQOhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 10:37:23 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: split ap/ibss wep key install process
References: <1439467846-8351-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 17 Aug 2015 17:37:15 +0300
In-Reply-To: <1439467846-8351-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 13 Aug 2015 14:10:46 +0200")
Message-ID: <87pp2mdlr8.fsf@kamboji.qca.qualcomm.com> (sfid-20150817_163731_969431_B4CE0F5D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Apparently it's not safe to install both pairwise
> and groupwise keys on AP vdevs as it can cause
> traffic to stop working in some multi-vif
> (WPA+WEP) cases.
>
> Fixes: ce90b27128c2 ("ath10k: fix multiple key static wep with ibss")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
