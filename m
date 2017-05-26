Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36860 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761229AbdEZLP6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 May 2017 07:15:58 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: Re: [PATCH 4.12 REGRESSION fix] brcmfmac: Use ALIGNMENT rather then hardcoded "4" for bus:txglomalign
References: <20170526110255.21342-1-hdegoede@redhat.com>
Date: Fri, 26 May 2017 14:15:31 +0300
In-Reply-To: <20170526110255.21342-1-hdegoede@redhat.com> (Hans de Goede's
        message of "Fri, 26 May 2017 13:02:55 +0200")
Message-ID: <87d1avrhrg.fsf@kamboji.qca.qualcomm.com> (sfid-20170526_131713_814840_8ED20AE4)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> writes:

> From: Arend Van Spriel <arend.vanspriel@broadcom.com>
>
> This fixes the following errors showing up in dmesg:
>
> [   32.528271] brcmfmac: brcmf_sdio_rxglom: sublen 524 not multiple of 8
> [   32.528296] brcmfmac: brcmf_sdio_rxglom: sublen 84 not multiple of 8
> [   33.063241] brcmfmac: brcmf_sdio_rxglom: sublen 1492 not multiple of 8
>
> Fixes: 6e84ab604bde ("properly align buffers ... with 64 bit DMA")
> Suggested-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

I'll queue this to 4.12.

-- 
Kalle Valo
