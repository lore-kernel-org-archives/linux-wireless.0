Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54283 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750816AbcIIJMn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Sep 2016 05:12:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] brcmfmac: add support for bcm4339 chip with modalias
 sdio:c00v02D0d4339
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1473072133-4266-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160909091242.D584461E9C@smtp.codeaurora.org> (sfid-20160909_111246_874584_90FF1E86)
Date: Fri,  9 Sep 2016 09:12:42 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> The driver already supports the bcm4339 chipset but only for the variant
> that shares the same modalias as the bcm4335, ie. sdio:c00v02D0d4335.
> It turns out that there are also bcm4339 devices out there that have a
> more distiguishable modalias sdio:c00v02D0d4339.
> 
> Reported-by: Steve deRosier <derosier@gmail.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 2 patches applied to wireless-drivers-next.git:

634faf368690 brcmfmac: add support for bcm4339 chip with modalias sdio:c00v02D0d4339
5251b6be8bb5 brcmfmac: sdio: shorten retry loop in brcmf_sdio_kso_control()

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9313473/
