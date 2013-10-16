Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:6374 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3JPMsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Oct 2013 08:48:47 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/7] ath10k: fix WMI atomic usage
References: <20131015184548.14123.56949.stgit@localhost6.localdomain6>
Date: Wed, 16 Oct 2013 15:48:42 +0300
In-Reply-To: <20131015184548.14123.56949.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Tue, 15 Oct 2013 21:46:37 +0300")
Message-ID: <87fvs1755h.fsf@kamboji.qca.qualcomm.com> (sfid-20131016_144851_118583_FD313DD8)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Some WMI calls were made in atomic contex, these patches fix
> those. Please review.
>
> ---
>
> Kalle Valo (2):
>       ath10k: fix ath10k_bss_assoc() to not sleep in atomic context
>       ath10k: add might_sleep() to ath10k_wmi_cmd_send()
>
> Michal Kazior (5):
>       ath10k: use workqueue to set WEP TX key
>       ath10k: fix add_interface failure handling
>       ath10k: track vif list internally
>       ath10k: fix scheduling while atomic config bug
>       ath10k: remove unnecessary checks

All patches applied.

-- 
Kalle Valo
