Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52992 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbCTHGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 03:06:41 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/8] brcmfmac: avoid runtime-pm for sdio host controller
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426681528-15831-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150320070641.355FD140E26@smtp.codeaurora.org> (sfid-20150320_080644_840150_C8975B3C)
Date: Fri, 20 Mar 2015 07:06:41 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Several host controllers supporting runtime-pm are causing issues
> with our sdio wireless cards because they disable the sdio interrupt
> upon going into runtime suspend. This patch avoids that by doing
> a pm_runtime_forbid() call during the probe. Tested with Sony Vaio
> Duo 13 which uses sdhci-acpi host controller.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 8 patches applied to wireless-drivers-next.git:

063d51776bd6 brcmfmac: avoid runtime-pm for sdio host controller
2c64e16d1ff1 brcmfmac: Add necessary memory barriers for SDIO.
a74196bb67c4 brcmfmac: Update msgbuf commonring size for improved throughput.
ef5671d29df5 brcmfmac: Remove unnecessary new-line in pcie console logging.
7fca40eb0030 brcmfmac: add MODULE_FIRMWARE() macros for bcm4356 PCIe device
25911556283e brcmfmac: add support for BCM43430 SDIO chipset
228a71763d9f brcmfmac: only support the BCM43455/7 device
55ab9a72bd32 brcmfmac: remove support for unreleased BCM4354 PCIe

Kalle Valo
