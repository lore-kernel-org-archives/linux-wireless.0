Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:37299 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbcJLFei (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 01:34:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: Revert "ath9k_hw: implement temperature compensation support for
 AR9003+"
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161011174649.19210-1-nbd@nbd.name>
References: <20161011174649.19210-1-nbd@nbd.name>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-wireless@vger.kernel.org>, <kvalo@codeaurora.org>
Message-ID: <7995a06988404eb9a0a595168bbfb2ce@euamsexm01a.eu.qualcomm.com> (sfid-20161012_073455_182555_C005F281)
Date: Wed, 12 Oct 2016 07:21:14 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau <nbd@nbd.name> wrote:
> This reverts commit 171f6402e4aa5cd3b8407f82501f7ea21fa54ccc.
> Some users report that this commit causes a regression in performance
> under some conditions.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

I added these to the commit log:

    Fixes: 171f6402e4aa ("ath9k_hw: implement temperature compensation support for AR9003+")
    Cc: <stable@vger.kernel.org> #4.8

My understanding is that the commit is not in 4.7, hence only cc stable 4.8.

-- 
https://patchwork.kernel.org/patch/9371479/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
