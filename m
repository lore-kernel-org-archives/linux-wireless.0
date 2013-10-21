Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25387 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3JUOPi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 10:15:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] ath10k: fixes 2013-10-15
References: <20131016134503.25095.8044.stgit@localhost6.localdomain6>
Date: Mon, 21 Oct 2013 17:15:27 +0300
In-Reply-To: <20131016134503.25095.8044.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Wed, 16 Oct 2013 16:45:35 +0300")
Message-ID: <8738nuu2v4.fsf@kamboji.qca.qualcomm.com> (sfid-20131021_161542_286020_FAC5B983)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> This is Michal's patchset which he said:
>
>   This is a bunch of fixes I've had queued up for
>   some time now. I was reluctant to send them without some additional checks
>   and because some of the fixes are not ideal. At least we can get a discussion
>   going if anything raises any serious concern.
>
> For v2 I added one patch myself, modified "ath10k: fix device initialization
> routine" to use ath10k_pci_write32() style of wrappers and fixed long line warnings
> from checkpatch.
>
> ---
>
> Kalle Valo (1):
>       ath10k: implement ath10k_pci_soc_read/write32()
>
> Michal Kazior (7):
>       ath10k: prevent starting monitor without a vdev
>       ath10k: add sanity checks for monitor management
>       ath10k: fix endianess in prints
>       ath10k: fix NSS reporting in RX
>       ath10k: fix NULL deref upon early FW crash
>       ath10k: fix FW crashes on heavy TX on 10.1.389 AP FW

These patches applied.

>       ath10k: fix device initialization routine

I dropped this patch for now, because of some of the warm reset issues.
We need to investigate more.

-- 
Kalle Valo
