Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53892 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdALK5p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 05:57:45 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: htc: Removal of unused struct members
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1481374721-16354-1-git-send-email-erik.stromdahl@gmail.com>
References: <1481374721-16354-1-git-send-email-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Erik Stromdahl" <erik.stromdahl@gmail.com>
Message-ID: <cb5a139fbc2440978aa2a66ed2e607a0@euamsexm01a.eu.qualcomm.com> (sfid-20170112_115747_956618_CEA1E695)
Date: Thu, 12 Jan 2017 11:52:11 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
> Removed tx_credits_per_max_message and tx_credit_size
> from struct ath10k_htc_ep since they are not used
> anywhere in the code.
> 
> They are just written, never read.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

2 patches applied to ath-next branch of ath.git, thanks.

7bc7441e4da3 ath10k: htc: removal of unused struct members
d48b62ceeea2 ath10k: htc: simplified credit distribution

-- 
https://patchwork.kernel.org/patch/9469283/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
