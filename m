Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36876 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932406AbcKOPE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Nov 2016 10:04:26 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix failure to send NULL func frame for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1476257342-3241-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1476257342-3241-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <755fcf2ee5da4f8f9f0e618e1bece8c1@euamsexm01a.eu.qualcomm.com> (sfid-20161115_160429_058186_2BF6B90C)
Date: Tue, 15 Nov 2016 16:04:08 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> This partially reverts 'commit 2cdce425aa33
> ("ath10k: Fix broken NULL func data frame status for 10.4")'
> Unfortunately this breaks sending NULL func and the existing
> issue of obtaining proper tx status for NULL function will be
> fixed. Also update the comments for feature flag added to be
> useless and not working
> 
> Fixes: 2cdce425aa33 "ath10k: Fix broken NULL func data frame status for
> 10.4"
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

fcf7cf1551ca ath10k: fix failure to send NULL func frame for 10.4

-- 
https://patchwork.kernel.org/patch/9372171/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
