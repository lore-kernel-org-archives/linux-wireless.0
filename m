Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55666 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751540AbeB0QXY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 11:23:24 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/8] brcmfmac: move brcmf_bus_preinit() call just after changing
 bus state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1519082065-10128-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1519082065-10128-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20180227162323.E83AD60285@smtp.codeaurora.org> (sfid-20180227_172328_261168_7D7A56B9)
Date: Tue, 27 Feb 2018 16:23:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> Moving the brcmf_bus_preinit() call allows the bus code to do some
> required initialization before handling firmware control messages.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

8 patches applied to wireless-drivers-next.git, thanks.

da472385a29f brcmfmac: move brcmf_bus_preinit() call just after changing bus state
4b5adc736828 brcmfmac: move allocation of control rx buffer to brcmf_sdio_bus_preinit()
262f2b53f679 brcmfmac: call brcmf_attach() just before calling brcmf_bus_started()
a7f4a80c0070 brcmfmac: usb: call brcmf_usb_up() during brcmf_bus_preinit()
0542503c4c16 brcmfmac: move brcmf_attach() function in core.c
de2a3027f6f1 brcmfmac: remove brcmf_bus_started() from bus api
d678296bfb9a brcmfmac: change log level for some low-level sdio functions
2d6edad4b2da brcmfmac: remove duplicate pointer variable from brcmf_sdio_firmware_callback()

-- 
https://patchwork.kernel.org/patch/10229211/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
