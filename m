Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48114 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753641AbeDSQUw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 12:20:52 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] ath10k: add inlined wrappers for htt tx ops
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180415122228.12565-2-erik.stromdahl@gmail.com>
References: <20180415122228.12565-2-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org,
        Erik Stromdahl <erik.stromdahl@gmail.com>
Message-Id: <20180419162051.B21156079B@smtp.codeaurora.org> (sfid-20180419_182055_799021_4858815F)
Date: Thu, 19 Apr 2018 16:20:51 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:

> These wrappers makes the HTT ops align better with the HIF ops
> (where similar wrappers are used).
> 
> It also makes it easier for a target to have unsupported ops
> (by letting the corresponding function pointer be NULL).
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

2 patches applied to ath-next branch of ath.git, thanks.

5df6e1313044 ath10k: add inlined wrappers for htt tx ops
9a5511d5f24f ath10k: add inlined wrappers for htt rx ops

-- 
https://patchwork.kernel.org/patch/10341545/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
