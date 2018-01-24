Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56908 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934021AbeAXQDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 11:03:03 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: assure bcdc dcmd api does not return value > 0
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1516654000-25314-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1516654000-25314-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180124160303.2D2DC601D2@smtp.codeaurora.org> (sfid-20180124_170308_081874_9A4A81A2)
Date: Wed, 24 Jan 2018 16:03:03 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> The protocol layer api defines callbacks for dongle commands.
> Although not really well documented these should only return an
> error code in case of an error, or 0 upon success. In the bcdc
> protocol it can return value above 0 and we carry a fix in the
> caller of the protocol layer api. This patch makes it adhere to
> the intent of the api as described above.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

2 patches applied to wireless-drivers-next.git, thanks.

5242a5444e0b brcmfmac: assure bcdc dcmd api does not return value > 0
b69c1df47281 brcmfmac: separate firmware errors from i/o errors

-- 
https://patchwork.kernel.org/patch/10179309/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
