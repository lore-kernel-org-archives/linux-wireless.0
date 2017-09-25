Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:61157 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933072AbdIYHV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Sep 2017 03:21:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: wcn36xx: Disable 5GHz for wcn3620
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1505824403-26798-1-git-send-email-loic.poulain@linaro.org>
References: <1505824403-26798-1-git-send-email-loic.poulain@linaro.org>
To: Loic Poulain <loic.poulain@linaro.org>
CC: <k.eugene.e@gmail.com>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <wcn36xx@lists.infradead.org>,
        Loic Poulain <loic.poulain@linaro.org>
Message-ID: <92a67632b76a475497ac1ad8a2ee13a1@euamsexm01a.eu.qualcomm.com> (sfid-20170925_095443_244125_74FF48C0)
Date: Mon, 25 Sep 2017 09:21:19 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> wrote:

> wcn3620 can only operate on 2.4GHz band due to RF limitation.
> If wcn36xx digital block is associated with an external IRIS
> RF module, retrieve the id and disable 5GHz band in case of
> wcn3620 id.
> 
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

fd52bdae9ab0 wcn36xx: Disable 5GHz for wcn3620

-- 
https://patchwork.kernel.org/patch/9958797/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
