Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:12469 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3GSLID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jul 2013 07:08:03 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/3] ath10k: fixes
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 19 Jul 2013 14:07:55 +0300
In-Reply-To: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 18 Jul 2013 08:33:10 +0200")
Message-ID: <871u6u4xkk.fsf@kamboji.qca.qualcomm.com> (sfid-20130719_130808_136089_E745DE11)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> Here are some fixes for ath10k. The rts threshold
> patch addresses my mistake in commit
> 9aeb6fe53d1f0d6e58658484ce9ad7b59f0ef16b which
> caused rts to be always enabled causing throughput
> issues in some cases.
>
>
> Michal Kazior (3):
>   ath10k: prevent HTC from being used after stopping
>   ath10k: fix memleak in mac setup
>   ath10k: fix rts/fragmentation threshold setup

Doesn't apply:

Applying: ath10k: prevent HTC from being used after stopping
Applying: ath10k: fix memleak in mac setup
Applying: ath10k: fix rts/fragmentation threshold setup
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/mac.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0003 ath10k: fix rts/fragmentation threshold setup


-- 
Kalle Valo
