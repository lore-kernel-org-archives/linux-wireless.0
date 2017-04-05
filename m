Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50526 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754073AbdDEHkA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Apr 2017 03:40:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Fix the Transmit Power Control stats display format
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1490962180-24054-1-git-send-email-c_mkenna@qti.qualcomm.com>
References: <1490962180-24054-1-git-send-email-c_mkenna@qti.qualcomm.com>
To: <c_mkenna@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mkenna@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
Message-ID: <87c5b76a4b7d41ef9cf1ec4691afa467@euamsexm01a.eu.qualcomm.com> (sfid-20170405_094011_025033_16B64DD9)
Date: Wed, 5 Apr 2017 09:39:52 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

c_mkenna@qti.qualcomm.com wrote:
> From: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>
> 
> This patch helps to fix TPC stats to display the stats
> properly. Here cosmetic change has been done to print the
> TPC stats for all the cases 1.CDD 2.STBC 3.TXBF
> 
> Signed-off-by: Maharaja Kennadyrajan <c_mkenna@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

e871fb6396f7 ath10k: fix the Transmit Power Control stats display format

-- 
https://patchwork.kernel.org/patch/9656133/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
