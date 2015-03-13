Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51428 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338AbbCMOLk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 10:11:40 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/7] brcmfmac: remove duplication of ramsize info
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426086693-13876-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150313141140.1175414161A@smtp.codeaurora.org> (sfid-20150313_151144_178752_5573E404)
Date: Fri, 13 Mar 2015 14:11:40 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Removing the ramsize from the brcmf_sdio structure to avoid
> duplication. The information is available in brcmf_chip
> structure.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

55b59fba0f0c brcmfmac: remove duplication of ramsize info
5ded1c251f8e brcmfmac: always perform cores checks
d380ebc9b6fb brcmfmac: rename chip download functions
38f29e1f42b1 brcmfmac: assure device is ready for download after brcmf_chip_attach()
0da32ba4ee66 brcmfmac: extract ram size info from internal memory registers
9819a9024eab brcmfmac: take save&restore memory into account for SDIO shared info
cf45932a74d4 brcmfmac: fix watchdog timer regression

Kalle Valo
