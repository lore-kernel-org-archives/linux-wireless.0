Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727029AbeITRMt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Sep 2018 13:12:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-09-19
References: <e184434e-04a0-18a9-0693-42eca0a45268@nbd.name>
Date: Thu, 20 Sep 2018 14:29:43 +0300
In-Reply-To: <e184434e-04a0-18a9-0693-42eca0a45268@nbd.name> (Felix Fietkau's
        message of "Wed, 19 Sep 2018 12:41:40 +0200")
Message-ID: <87bm8s1k60.fsf@kamboji.qca.qualcomm.com> (sfid-20180920_132949_946896_1FA6739E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> writes:

> Here's a large batch of mt76 code cleanup / deduplication / fixes,
> rebased to your latest wireless-drivers-next. This replaces the previous
> pull request.
>
> - Felix
>
> The following changes since commit 43e2f2904160b9a95aad77df9cbc1622910b8598:
>
>   Merge wireless-drivers into wireless-drivers-next (2018-09-17 17:41:02 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-09-19
>
> for you to fetch changes up to bf3741ada33bb4fabec99538b8014c054854912b:
>
>   mt76x0: usb: remove mt76_fw definition (2018-09-19 12:31:49 +0200)
>
> ----------------------------------------------------------------
> mt76 patches for 4.20
>
> * lots of mt76x0 cleanups / fixes
> * mt76x2u fixes
> * unify code between mt76x0, mt76x2e and mt76x2u
> * rename mt76x0 to mt76x0u
> * improve rx buffer allocation for all variants
> * prepare for adding mt76x0e (pci-e variant) support
>   add CONFIG_MT76x0E kconfig symbol
>
> ----------------------------------------------------------------

Pulled, thanks.

For others: I talked with Felix and we agreed that while this heavy
refactoring is going on Felix will apply mt76 patches for -next into his
tree and I'll apply mt76 patches for current -rc releases directly into
my wireless-drivers tree.

I'll also try to keep the patchwork up-to-date but as I do it manually
errors are prone to happen. Please let me know if something is wrong.
Here's a current link to list of mt76 patches not yet applied:

https://patchwork.kernel.org/project/linux-wireless/list/?q=mt76&order=date

-- 
Kalle Valo
