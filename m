Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:15861 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140AbaC1MX4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 08:23:56 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] ath10k: small cleanups to pci.c
References: <20140328073040.30438.17966.stgit@potku.adurom.net>
Date: Fri, 28 Mar 2014 14:23:51 +0200
In-Reply-To: <20140328073040.30438.17966.stgit@potku.adurom.net> (Kalle Valo's
	message of "Fri, 28 Mar 2014 09:32:14 +0200")
Message-ID: <87a9cawlyg.fsf@kamboji.qca.qualcomm.com> (sfid-20140328_132418_756918_47F6BB8C)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> While looking at the cold reset problem I did some cleanup
> to pci.c.
>
> v2: In patch 1 fix how to check FW_IND_INITIALIZED and also check for 0xffffffff.
>
> ---
>
> Kalle Valo (8):
>       ath10k: cleanup ath10k_pci_wait_for_target_init()
>       ath10k: add module parameter to disable cold reset
>       ath10k: fix name of target_ps module parameter
>       ath10k: advertise only firmware API 2 files
>       ath10k: delete ar_pci->fw_indicator_address
>       ath10k: improve pci debug messages
>       ath10k: add module parameter values to the pci info print
>       ath10k: print chip id during boot

All eight patches applied.

-- 
Kalle Valo
