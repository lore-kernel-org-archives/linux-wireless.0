Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51244 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750710AbeAHRTM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:19:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/11] brcmfmac: Remove {r,w}_sdreg32
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513687637-5555-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180108171911.EBE0B6079C@smtp.codeaurora.org> (sfid-20180108_181916_794637_96F40F55)
Date: Mon,  8 Jan 2018 17:19:11 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Ian Molton <ian@mnementh.co.uk>
> 
> Remove yet another IO function from the code and replace with one
> that already exists.
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> [arend: keep address calculation, ie. (base + offset) in one line]
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

8 patches applied to wireless-drivers-next.git, thanks.

3d110df8f747 brcmfmac: Remove {r,w}_sdreg32
dbda7dacb79a brcmfmac: Rename buscore to core for consistency
874bb8e49b7c brcmfmac: stabilise the value of ->sbwad in use for some xfer routines.
508422f3695b brcmfmac: Correctly handle accesses to SDIO func0
99d7b6fdfc8c brcmfmac: Remove func0 from function array
bcadaaa097c7 brcmfmac: More efficient and slightly easier to read fixup for 4339 chips
00eb62cfc5f8 brcmfmac: Replace function index with function pointer
9c3438ed215a brcmfmac: Clean up interrupt macros

-- 
https://patchwork.kernel.org/patch/10123219/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
