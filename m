Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47274 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbeB0QsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:48:00 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath9k: Fix airtime calculation for quarter/half channels
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519137703-9000-1-git-send-email-Wojciech.Dubowik@neratec.com>
References: <1519137703-9000-1-git-send-email-Wojciech.Dubowik@neratec.com>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Message-Id: <20180227164759.EE9CE6070A@smtp.codeaurora.org> (sfid-20180227_174804_147757_C6FAFF07)
Date: Tue, 27 Feb 2018 16:47:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> wrote:

> The bitrate value for airtime calculation is specified for
> full rates. We need to divide it for 5 and 10MHz channels to
> get correct result.
> 
> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

91f1ee65d999 ath9k: Fix airtime calculation for quarter/half channels
52c528ffaf1d ath9k: Fix ack SIFS time for quarter/half channels

-- 
https://patchwork.kernel.org/patch/10230167/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
