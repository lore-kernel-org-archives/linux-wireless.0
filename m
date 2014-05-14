Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45877 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440AbaENNnQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 09:43:16 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <greearb@candelatech.com>,
	<linux-wireless@vger.kernel.org>, <apenwarr@gmail.com>
Subject: Re: [PATCH 0/2] ath10k: 2014-05-07 fixes
References: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 14 May 2014 16:43:08 +0300
In-Reply-To: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 7 May 2014 14:33:24 +0200")
Message-ID: <87k39ofpcj.fsf@kamboji.qca.qualcomm.com> (sfid-20140514_154318_791134_2F809B33)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> These 2 patches address kernel panics reported by
> Avery recently. One of them was most likely
> reported by Ben some time ago already.
>
> I've never seen these panics myself. It'd be great
> if you guys could give it a try and (assuming
> you're capable of reproducing) see if it actually
> helps.
>
>
> Michal Kazior (2):
>   ath10k: fix htt rx ring clean up
>   ath10k: fix handling of wierd MSDU chaining cases

Thanks, applied.

I didn't see any reports if these help or not, but the patches looked
good and I applied them anyway.

-- 
Kalle Valo
