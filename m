Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:44386 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754560AbeAHSY6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 13:24:58 -0500
Date: Mon, 8 Jan 2018 23:54:47 +0530
From: Himanshu Jha <himanshujha199640@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mcgrof@kernel.org
Subject: Re: brcmfmac: Use zeroing memory allocator than allocator/memset
Message-ID: <20180108182447.GA31020@himanshu-Vostro-3559> (sfid-20180108_192515_108663_175DFF44)
References: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com>
 <20180108172322.6AD8560B1B@smtp.codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180108172322.6AD8560B1B@smtp.codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 08, 2018 at 05:23:22PM +0000, Kalle Valo wrote:
> Himanshu Jha <himanshujha199640@gmail.com> wrote:
> 
> > Use dma_zalloc_coherent for allocating zeroed
> > memory and remove unnecessary memset function.
> > 
> > Done using Coccinelle.
> > Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> > 0-day tested with no failures.
> > 
> > Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> > Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> > Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> 
> Failed to apply:
> 
> fatal: corrupt patch at line 29
> error: could not build fake ancestor
> Applying: brcmfmac: Use zeroing memory allocator than allocator/memset
> Patch failed at 0001 brcmfmac: Use zeroing memory allocator than allocator/memset
> The copy of the patch that failed is found in: .git/rebase-apply/patch
> 
> Patch set to Changes Requested.

Sorry! That failed because I manually adjusted the arguments to prevent
80 character limit in the patch generated.

I will rebase and send v2 with updates.

-- 
Thanks
Himanshu Jha
