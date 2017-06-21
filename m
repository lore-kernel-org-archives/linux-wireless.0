Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54232 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751069AbdFUQjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 12:39:41 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/2] brcmfmac: Use separate firmware for revision 0 of the
 brcm43430 chip
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170616131449.12108-2-hdegoede@redhat.com>
References: <20170616131449.12108-2-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jelle van der Waa <jelle@vdwaa.nl>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20170621152125.0735060854@smtp.codeaurora.org> (sfid-20170621_183947_855511_768D7E6E)
Date: Wed, 21 Jun 2017 15:21:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> wrote:

> The brcm43430 chip needs different firmware files for chip revision 0
> and 1. The file currently in linux-firmware is for revision 1 only.
> 
> This commit makes brcmfmac request brcmfmac43430a0-sdio.bin instead
> of brcmfmac43430-sdio.bin for revision 0 chips.
> 
> Note that the behavior for revision 1 chips is not changed, ideally those
> would load brcmfmac43430a1-sdio.bin, but that will break existing setups.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

1278bd149839 brcmfmac: Use separate firmware for revision 0 of the brcm43430 chip

-- 
https://patchwork.kernel.org/patch/9791523/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
