Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15710 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753098AbdCTPWx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 11:22:53 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix warnings from an earlier commit
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <148965546273.3007.5273967631982279383.stgit@potku.adurom.net>
References: <148965546273.3007.5273967631982279383.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <1569c6bba3bc400c9800e036c3731b9c@euamsexm01a.eu.qualcomm.com> (sfid-20170320_162336_632796_4C0B8FD2)
Date: Mon, 20 Mar 2017 16:22:46 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> I failed to notice that commit 523f6701dbab ("ath10k: update available channel
> list for 5G radio") added two new warnings:
> 
> drivers/net/wireless/ath/ath10k/mac.c:3129:6: warning: symbol 'ath10k_mac_update_channel_list' was not declared. Should it be static?
> drivers/net/wireless/ath/ath10k/mac.c:3170: Alignment should match open parenthesis
> 
> Fix those.
> 
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

46bc92bedbd3 ath10k: fix warnings from an earlier commit

-- 
https://patchwork.kernel.org/patch/9627713/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
