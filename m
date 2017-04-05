Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36132 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753520AbdDEHdA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:33:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: use octal permission representation
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1487598027-17324-1-git-send-email-marcin.rokicki@tieto.com>
References: <1487598027-17324-1-git-send-email-marcin.rokicki@tieto.com>
To: Marcin Rokicki <marcin.rokicki@tieto.com>
CC: <ath10k@lists.infradead.org>,
        Marcin Rokicki <marcin.rokicki@tieto.com>,
        <linux-wireless@vger.kernel.org>
Message-ID: <cbcc82a65ec344d6bf413d5c41ed4a94@euamsexm01a.eu.qualcomm.com> (sfid-20170405_093304_328744_A45171E3)
Date: Wed, 5 Apr 2017 09:32:52 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcin Rokicki <marcin.rokicki@tieto.com> wrote:
> Fix output from checkpatch.pl like:
>  Symbolic permissions 'S_IRUSR' are not preferred.
>  Consider using octal permissions '0400'.
> 
> Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>

This introduced a new checkpatch warning:

drivers/net/wireless/ath/ath10k/debug.c:2494: Alignment should match open parenthesis

I fixed that in the pending branch.

-- 
https://patchwork.kernel.org/patch/9582889/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
