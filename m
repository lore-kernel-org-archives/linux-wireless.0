Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64914 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbcBBLUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 06:20:11 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Raja Mani <rmani@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] add ahb (qca4019) support
References: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com>
Date: Tue, 2 Feb 2016 13:19:58 +0200
In-Reply-To: <1453888473-2879-1-git-send-email-rmani@qti.qualcomm.com> (Raja
	Mani's message of "Wed, 27 Jan 2016 15:24:21 +0530")
Message-ID: <87mvrjgy01.fsf@kamboji.qca.qualcomm.com> (sfid-20160202_122017_163080_E0BFFE42)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Raja Mani <rmani@qti.qualcomm.com> writes:

> This patch series attempts to add ahb support (qca4019) in ath10k.
> All ahb related ops are grouped and kept in new file called ahb.c/ahb.h 
> and will get compiled/linked to ath10k_pci.ko based on kernel config flag
> CONFIG_ATH10K_AHB flag. Most of function in pci.c file are reusable and
> called as it's without changing function name (ath10k_pci_*) in ahb.c.
>
> Still, some more work needs to be done in ath10k driver to make ahb
> functional (qca4019). Hence, i disabled device probing in ahb module
> for the time being. I'll post follow patch soon to enable it along
> with missing patches.
>
> The patch to update device tree bindings document with list of DT node
> attributes referred in this patch series is already committed in ath.git,
>
>       https://patchwork.kernel.org/patch/8022221/
>
> Raja Mani (12):
>   ath10k: make some of ath10k_pci_* func reusable
>   ath10k: make ath10k_pci_read32/write32() ops more generic
>   ath10k: pull reusable code from pci probe and remove for ahb
>   ath10k: add basic skeleton to support ahb
>   ath10k: include qca4019 register map table
>   ath10k: add helper functions in ahb.c for reg rd/wr
>   ath10k: add clock ctrl related functions in ahb
>   ath10k: add reset ctrl related functions in ahb
>   ath10k: add chip and bus halt logic in ahb
>   ath10k: include irq related functions in ahb
>   ath10k: add resource init and deinit in ahb
>   ath10k: expose hif ops for ahb

Applied, thanks.

-- 
Kalle Valo
