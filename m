Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56268 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752592AbeAHRXX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:23:23 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: Use zeroing memory allocator than allocator/memset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com>
References: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com>
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org,
        Himanshu Jha <himanshujha199640@gmail.com>
Message-Id: <20180108172322.93BC060B1D@smtp.codeaurora.org> (sfid-20180108_182422_377807_F78EF1A8)
Date: Mon,  8 Jan 2018 17:23:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Himanshu Jha <himanshujha199640@gmail.com> wrote:

> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
> 
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
> 
> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

Failed to apply:

fatal: corrupt patch at line 29
error: could not build fake ancestor
Applying: brcmfmac: Use zeroing memory allocator than allocator/memset
Patch failed at 0001 brcmfmac: Use zeroing memory allocator than allocator/memset
The copy of the patch that failed is found in: .git/rebase-apply/patch

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/patch/10137819/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
