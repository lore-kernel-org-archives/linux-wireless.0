Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5084 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbaHYIez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2014 04:34:55 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/5] ath10k: fixes 2014-08-07, part 3
References: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
Date: Mon, 25 Aug 2014 11:34:50 +0300
In-Reply-To: <1408710798-25198-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 22 Aug 2014 14:33:13 +0200")
Message-ID: <87y4ud55n9.fsf@kamboji.qca.qualcomm.com> (sfid-20140825_103459_094009_BE57F11D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> This is part 3 (of 3) of my patches. Split for
> your reviewing pleasure.
>
> This is related to start/restart sequences.
>
> This is based on:
>   [PATCH v2 0/6] ath10k: fixes 2014-08-07, part 2
>
> v2:
>  * patch [2/5] replaced
>  * fixes, see notes
>
>
> Michal Kazior (5):
>   ath10k: rework posting pci rx buffers
>   ath10k: update comment regarding warm reset
>   ath10k: ignore ar_pci->started in pipe cleanup
>   ath10k: remove ar_pci->started
>   ath10k: flush hif buffers before recovery

Thanks, all five patches applied.

-- 
Kalle Valo
