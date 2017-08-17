Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:2646 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdHQEUI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Aug 2017 00:20:08 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/6] ath10k: refactor firmware crashdump code to coredump.c
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <150278538298.22482.10986802411848917689.stgit@potku.adurom.net>
References: <150278538298.22482.10986802411848917689.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <ec54c0ff3af546d2a52d75428c38d06b@euamsexm01a.eu.qualcomm.com> (sfid-20170817_062143_245431_51AAF485)
Date: Thu, 17 Aug 2017 06:20:02 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> In preparation to add RAM dump support. No functional changes, only moving code
> and renaming function names.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

With only this patch applied, and CONFIG_DEV_COREDUMP disabled, there's a build error:

drivers/net/wireless/ath/ath10k/coredump.c:24:30: error: redefinition of 'ath10k_coredump_new'
drivers/net/wireless/ath/ath10k/coredump.c:130:5: error: redefinition of 'ath10k_coredump_submit'

-- 
https://patchwork.kernel.org/patch/9901243/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
