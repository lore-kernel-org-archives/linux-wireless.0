Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaHLIC6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 04:02:58 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/6] ath10k: fixes 2014-08-07, part 1
References: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 12 Aug 2014 10:56:24 +0300
In-Reply-To: <1407402212-29809-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Thu, 7 Aug 2014 11:03:26 +0200")
Message-ID: <87lhquqgyf.fsf@kamboji.qca.qualcomm.com> (sfid-20140812_100304_316891_AD16F2F6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is part 1 (of 3) of my patches. Split for
> your reviewing pleasure.
>
> This one is mostly non-functional (just cleanups)
> except the removal of soc powersave.
>
>
> Michal Kazior (6):
>   ath10k: embed ar_pci inside ar
>   ath10k: remove target soc ps code
>   ath10k: remove pci features var
>   ath10k: group some pci probing helpers
>   ath10k: remove htc->stopped

Thanks, these five patches applied.

>   ath10k: move fw init print

I dropped this one as I think it's buggy.

-- 
Kalle Valo
