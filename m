Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:48282 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICGuS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Sep 2013 02:50:18 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ath10k: pci cleanup
References: <20130901070020.14695.16694.stgit@localhost6.localdomain6>
Date: Tue, 3 Sep 2013 09:50:12 +0300
In-Reply-To: <20130901070020.14695.16694.stgit@localhost6.localdomain6> (Kalle
	Valo's message of "Sun, 01 Sep 2013 10:01:24 +0300")
Message-ID: <87r4d61jrv.fsf@kamboji.qca.qualcomm.com> (sfid-20130903_085023_147046_7B973531)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> Small PCI related code cleanup. Depends on Michal's CE
> clean patchset.
>
> v2:
>
> o remove unnecessary cast in patch 3 (from Gabor)
>
> ---
>
> Kalle Valo (7):
>       ath10k: pci: make host_ce_config_wlan[] more readable
>       ath10k: make target_ce_config_wlan more readable
>       ath10k: remove void pointer from struct ath10k_pci_compl
>       ath10k: convert ath10k_pci_reg_read/write32() to take struct ath10k
>       ath10k: clean up ath10k_ce_completed_send_next_nolock()
>       ath10k: convert ath10k_pci_wake() to return
>       ath10k: simplify ath10k_ce_init() wake up handling

All seven applied.

-- 
Kalle Valo
