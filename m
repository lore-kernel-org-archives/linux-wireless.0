Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35926 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751549AbdATJsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 04:48:20 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: add support for BCM43455 with modalias
 sdio:c00v02D0dA9BF
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
References: <20170116101757.20483-1-martin.blumenstingl@googlemail.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-mmc@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
        linux-wireless@vger.kernel.org, ulf.hansson@linaro.org,
        arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Message-Id: <20170120094814.E2D30607CD@smtp.codeaurora.org> (sfid-20170120_104823_601035_5EFB254A)
Date: Fri, 20 Jan 2017 09:48:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> wrote:
> BCM43455 is a more recent revision of the BCM4345. Some of the BCM43455
> got a dedicated SDIO device ID which is currently not supported by
> brcmfmac.
> Adding the new sdio_device_id to brcmfmac is enough to get the BCM43455
> supported because the chip itself is already supported (due to BCM4345
> support in the driver).
> 
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Reviewed-by: Andreas Färber <afaerber@suse.de>
> Tested-by: Andreas Färber <afaerber@suse.de>

Patch applied to wireless-drivers-next.git, thanks.

a62a77881b1b brcmfmac: add support for BCM43455 with modalias sdio:c00v02D0dA9BF

-- 
https://patchwork.kernel.org/patch/9518447/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
