Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53062 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbeAHRUn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:20:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [09/11] brcmfmac: Remove array of functions
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1513687637-5555-10-git-send-email-arend.vanspriel@broadcom.com>
References: <1513687637-5555-10-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>
Message-Id: <20180108172042.CF5AF60346@smtp.codeaurora.org> (sfid-20180108_182047_380575_0ECB452A)
Date: Mon,  8 Jan 2018 17:20:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Replace the array of functions with a pair of pointers to the
> relevant functions.
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Failed to apply:

fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c).
error: could not build fake ancestor
Applying: brcmfmac: Remove array of functions
Patch failed at 0001 brcmfmac: Remove array of functions
The copy of the patch that failed is found in: .git/rebase-apply/patch

3 patches set to Changes Requested.

10123215 [09/11] brcmfmac: Remove array of functions
10123207 [10/11] brcmfmac: add comment block in brcmf_sdio_buscore_read()
10123205 [11/11] brcmfmac: rename brcmf_sdiod_buff_{read,write}() functions

-- 
https://patchwork.kernel.org/patch/10123215/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
