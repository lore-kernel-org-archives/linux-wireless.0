Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38334 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752804AbeAKTxc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 14:53:32 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Use zeroing memory allocator than allocator/memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515444331-19509-1-git-send-email-himanshujha199640@gmail.com>
References: <1515444331-19509-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com,
        Himanshu Jha <himanshujha199640@gmail.com>
Message-Id: <20180111195331.695C2601D4@smtp.codeaurora.org> (sfid-20180111_205358_268251_A1011203)
Date: Thu, 11 Jan 2018 19:53:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
> 
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Patch applied to wireless-drivers-next.git, thanks.

b7acadaf0387 brcmfmac: Use zeroing memory allocator than allocator/memset

-- 
https://patchwork.kernel.org/patch/10150583/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
