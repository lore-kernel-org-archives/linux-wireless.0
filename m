Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40660 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbcGRTld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2016 15:41:33 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: brcmfmac: restore stopping netdev queue when bus clogs up
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1468577794-12606-1-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160718194132.81B706034D@smtp.codeaurora.org> (sfid-20160718_214135_817823_F06F384D)
Date: Mon, 18 Jul 2016 19:41:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> When the host-interface bus has hard time handling transmit packets
> it informs higher layer about this and it would stop the netdev
> queue when needed. However, since commit 9cd18359d31e ("brcmfmac:
> Make FWS queueing configurable.") this was broken. With this patch
> the behaviour is restored.
> 
> Cc: stable@vger.kernel.org # v4.5, v4.6, v4.7
> Fixes: 9cd18359d31e ("brcmfmac: Make FWS queueing configurable.")
> Tested-by: Per Förlin <per.forlin@gmail.com>
> Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

82bc9ab6a8f5 brcmfmac: restore stopping netdev queue when bus clogs up

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9231603/

