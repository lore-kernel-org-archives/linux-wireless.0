Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13294 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751211AbdEDM50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 08:57:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v7,01/10] ath10k: htc: made static function public
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <149207213738.4590.816518386579937753.stgit@potku.adurom.net>
References: <149207213738.4590.816518386579937753.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <5322c7736c7843deb83e86354f42ecc7@eusanexr01a.eu.qualcomm.com> (sfid-20170504_145755_661614_97C9FF85)
Date: Thu, 4 May 2017 05:57:19 -0700
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Erik Stromdahl <erik.stromdahl@gmail.com>
> 
> Changed ath10k_htc_notify_tx_completion and
> ath10k_htc_process_trailer from static to non static.
> 
> These functions are needed by SDIO/mbox.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

10 patches applied to ath-next branch of ath.git, thanks.

3e0dd820f07f ath10k: htc: made static function public
680ebb4e7977 ath10k: htc: rx trailer lookahead support
ea1a3ddf6273 ath10k: htc: move htc ctrl ep connect to htc_init
fcd2113363dd ath10k: htc: refactorization
01d6fd6965ea ath10k: various sdio related definitions
60bdfffa1254 ath10k: add sdio extra initializations
34dd398a55ff ath10k: sdio get target info
04ff79467ec2 ath10k: htc: ready_ext msg support
f008d1537bf8 ath10k: different fw file name for sdio
d96db25d2025 ath10k: add initial SDIO support

-- 
https://patchwork.kernel.org/patch/9678959/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
