Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44524 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbbCMNRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 09:17:12 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/5] brcmfmac: Fix oops when SDIO device is removed.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1425663642-19725-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150313131709.A09FA140C9F@smtp.codeaurora.org> (sfid-20150313_141716_360683_AF835DAB)
Date: Fri, 13 Mar 2015 13:17:09 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> On removal of SDIO card both functions of card will be getting
> a remove call. When the first is hanging in ctrl frame xmit then
> the second will cause oops. This patch fixes the xmit ctrl
> handling in case of serious errors and also limits the handling
> for remove to function 1 only.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 5 patches applied to wireless-drivers-next.git:

de6878c8354d brcmfmac: Fix oops when SDIO device is removed.
b441ba8dc341 brcmfmac: Simplify watchdog sleep.
449e58b85c00 brcmfmac: Fix possible race-condition.
d375bc8a85a4 brcmfmac: Fix race condition in msgbuf ioctl processing.
9c51026509d7 brcmfmac: Add support for BCM4345 SDIO chipset.

Kalle Valo
