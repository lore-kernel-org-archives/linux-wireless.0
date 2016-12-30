Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32840 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751889AbcL3JTb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:19:31 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Enable advertising support for channel 169, 5Ghz
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1482852215-6438-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1482852215-6438-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
        <linux-wireless@vger.kernel.org>,
        Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <62f5c79aac6a4a72880cae899ae742e9@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101935_616034_F51535E6)
Date: Fri, 30 Dec 2016 10:19:24 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Enable advertising support for channel 169, 5Ghz so that
> based on the regulatory domain(country code) this channel
> shall be active for use. For example in countries like India
> this channel shall be available for use with latest regulatory updates
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

34c30b0a5e97 ath10k: enable advertising support for channel 169, 5Ghz

-- 
https://patchwork.kernel.org/patch/9489307/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
