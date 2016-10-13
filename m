Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2640 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754420AbcJMLTH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 07:19:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "ath9k_hw: implement temperature compensation support for
 AR9003+"
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161011174649.19210-1-nbd@nbd.name>
References: <20161011174649.19210-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <ff5cab4da1bf4868b5df7e6af98550b1@euamsexm01a.eu.qualcomm.com> (sfid-20161013_131913_458073_446859A1)
Date: Thu, 13 Oct 2016 13:15:30 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> This reverts commit 171f6402e4aa5cd3b8407f82501f7ea21fa54ccc.
> Some users report that this commit causes a regression in performance
> under some conditions.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Patch applied to ath-current branch of ath.git, thanks.

304e5ac118cc Revert "ath9k_hw: implement temperature compensation support for AR9003+"

-- 
https://patchwork.kernel.org/patch/9371479/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
