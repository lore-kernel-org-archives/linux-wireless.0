Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40698 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbcGRTmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:42:02 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: defer DPC processing during probe
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468579153-14292-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160718194201.A808E6037B@smtp.codeaurora.org> (sfid-20160718_214207_377572_0241BCC6)
Date: Mon, 18 Jul 2016 19:42:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> The sdio dpc starts processing when in SDIOD_STATE_DATA. This state was
> entered right after firmware download. This patch moves that transition
> just before enabling sdio interrupt handling thus avoiding watchdog
> expiry which would put the bus to sleep while probing.
> 
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

fd3ed33f51c2 brcmfmac: defer DPC processing during probe

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9231665/

