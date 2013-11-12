Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13184 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3KLSHv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 13:07:51 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv2 00/13] ath10k: pci fixes 2013-10-30
References: <1383133346-8135-1-git-send-email-michal.kazior@tieto.com>
	<1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
Date: Tue, 12 Nov 2013 20:07:45 +0200
In-Reply-To: <1383894095-27998-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 8 Nov 2013 08:01:22 +0100")
Message-ID: <877gcda3ym.fsf@kamboji.qca.qualcomm.com> (sfid-20131112_190755_030836_11ECF2F2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> Hi,
>
> This patchset contains a slew of PCI/CE cleanups
> and fixes. The aim of the patchset is to deal with
> CE null dereference bugs Ben has been reporting on
> the mailing list for some time now.
>
> v2:
>  * fix prints
>  * fix commit messages
>  * add additional patch
>    (ath10k: reset device upon stopping/power down)
>
>
> Michal Kazior (13):
>   ath10k: remove ar_pci->ce_count
>   ath10k: don't forget to kill fw error tasklet
>   ath10k: split tasklet killing function
>   ath10k: rename ath10k_pci_reset_target()
>   ath10k: make sure to mask all CE irqs
>   ath10k: fix ath10k_ce_init() failpath
>   ath10k: remove meaningless check
>   ath10k: use ath10k_do_pci_wake/sleep
>   ath10k: propagate ath10k_ce_disable_interrupts() errors
>   ath10k: guard against CE corruption from firmware
>   ath10k: re-arrange PCI init code
>   ath10k: add and fix some PCI prints
>   ath10k: reset device upon stopping/power down

Thanks, all 13 applied.

-- 
Kalle Valo
