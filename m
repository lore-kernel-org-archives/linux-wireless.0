Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbeGYImA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jul 2018 04:42:00 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] brcmfmac: fix regression in parsing NVRAM for multiple
 devices
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180722214625.12101-1-zajec5@gmail.com>
References: <20180722214625.12101-1-zajec5@gmail.com>
To: =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Chung-Hsien Hsu <stanley.hsu@cypress.com>,
        Aditya Xavier <adityaxavier@gmail.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?utf-8?b?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-Id: <20180725073136.78C8960B77@smtp.codeaurora.org> (sfid-20180725_093141_296022_73583BCF)
Date: Wed, 25 Jul 2018 07:31:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki wrote:

> From: Rafał Miłecki <rafal@milecki.pl>
> 
> NVRAM is designed to work with Broadcom's SDK Linux kernel which fakes
> PCI domain 0 for all internal MMIO devices. Since official Linux kernel
> uses platform devices for that purpose there is a mismatch in numbering
> PCI domains.
> 
> There used to be a fix for that problem but it was accidentally dropped
> during the last firmware loading rework. That resulted in brcmfmac not
> being able to extract device specific NVRAM content and all kind of
> calibration problems.
> 
> Reported-by: Aditya Xavier <adityaxavier@gmail.com>
> Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() function")
> Cc: stable@vger.kernel.org # v4.17+
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers.git, thanks.

299b6365a3b7 brcmfmac: fix regression in parsing NVRAM for multiple devices

-- 
https://patchwork.kernel.org/patch/10539435/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
