Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934298AbeF1J6n (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 05:58:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: rename HTC_HOST_MAX_MSG_PER_BUNDLE define
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180615120423.4963-1-erik.stromdahl@gmail.com>
References: <20180615120423.4963-1-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-Id: <20180628095842.AA0D760234@smtp.codeaurora.org> (sfid-20180628_115851_228531_535183A4)
Date: Thu, 28 Jun 2018 09:58:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> This define is only used for RX bundling so it is more descriptive if
> RX is added to the define-name.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

ab687de9535c ath10k: rename HTC_HOST_MAX_MSG_PER_BUNDLE define
e4568eac0464 ath10k: replace hardcoded constant with define

-- 
https://patchwork.kernel.org/patch/10466281/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
