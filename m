Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:35039 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbaHYIaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:30:22 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/6] ath10k: ath10k: fixes 2014-08-07, part 2
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 25 Aug 2014 11:30:17 +0300
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Aug 2014 14:23:28 +0200")
Message-ID: <8738cl6kfa.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_103026_137894_42EAD7CC)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This is part 2 (of 3) of my patches. Split for
> your reviewing pleasure.
>
> This is related to irq handling only. Prepares for
> more start/restart sequences fixes.
>
> v2:
>  * patch [1/6] is from part 1
>  * patch [5/6] is new
>  * some fixes, see notes
>  * based on
>    f2c7cb774e3e0a8152b1134015c245ba0abddfc6 and
>    4 crash dump patches (v8) from Kalle
>
>
> Michal Kazior (6):
>   ath10k: move fw init print
>   ath10k: fix legacy irq workaround
>   ath10k: setup irq method in probe
>   ath10k: split ce irq/handler setup
>   ath10k: make sure to really disable irqs
>   ath10k: remove early irq handling

Thanks, all six patches applied.

-- 
Kalle Valo
