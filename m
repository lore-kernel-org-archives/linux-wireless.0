Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752634AbeAKRgQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Jan 2018 12:36:16 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [V2,1/3] brcmfmac: Remove array of functions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1515500574-16321-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1515500574-16321-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
Message-Id: <20180111173615.C8D5760A26@smtp.codeaurora.org> (sfid-20180111_183620_149228_103235D1)
Date: Thu, 11 Jan 2018 17:36:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Replace the array of functions with a pair of pointers to the
> relevant functions.
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

c9aa7a91de74 brcmfmac: Remove array of functions
32adbcaa5df4 brcmfmac: add comment block in brcmf_sdio_buscore_read()
378f6a16043e brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions

-- 
https://patchwork.kernel.org/patch/10151921/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
