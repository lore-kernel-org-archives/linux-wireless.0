Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750882AbeDYIWy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:22:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: add support for BCM4366E chipset
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1522743716-13628-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1522743716-13628-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Dan Haab <dhaab@luxul.com>,
        Dan Haab <dan.haab@luxul.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180425082253.DE2AE607DD@smtp.codeaurora.org> (sfid-20180425_102257_951210_A6563100)
Date: Wed, 25 Apr 2018 08:22:53 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Dan Haab <dhaab@luxul.com>
> 
> BCM4366E is a wireless chipset with a BCM43664 ChipCommon. It's
> supported by the same firmware as 4366c0.
> 
> Signed-off-by: Dan Haab <dan.haab@luxul.com>
> [arend: rebase patch and remove unnecessary definition]
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

1f589e2510d5 brcmfmac: add support for BCM4366E chipset

-- 
https://patchwork.kernel.org/patch/10320797/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
