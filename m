Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25307 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755531Ab3GWIrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jul 2013 04:47:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] ath10k: fixes
References: <1374129193-3533-1-git-send-email-michal.kazior@tieto.com>
	<1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 23 Jul 2013 11:47:16 +0300
In-Reply-To: <1374495211-20353-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 22 Jul 2013 14:13:27 +0200")
Message-ID: <87mwpdwtm3.fsf@kamboji.qca.qualcomm.com> (sfid-20130723_104732_745918_410BA2E4)
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
> v2: first patch is split now into two as requested
>     rebased on top of latest github master branch
>
>
> Michal Kazior (4):
>   ath10k: prevent HTC from being used after stopping
>   ath10k: don't reset HTC endpoints unnecessarily
>   ath10k: fix memleak in mac setup
>   ath10k: fix rts/fragmentation threshold setup

All four applied, thanks.

-- 
Kalle Valo
