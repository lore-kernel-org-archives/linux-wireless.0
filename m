Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58795 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbcFPPVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 11:21:03 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/6] brcmfmac: fix skb priority handling
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1464989472-29684-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <hante.meuleman@broadcom.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20160616152102.981CD6134F@smtp.codeaurora.org> (sfid-20160616_172108_564521_D6A32DBF)
Date: Thu, 16 Jun 2016 15:21:02 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> From: Hante Meuleman <hante.meuleman@broadcom.com>
> 
> SKBs can come with a prioriy. Currently a priority of 0..7 is
> assumed. But this assumption is incorrect. To fix this any
> priority of 0 or higher then 7 will be adjusted by calling
> cfg80211_classify8021d
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky Lin <franky.lin@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Signed-off-by: Hante Meuleman <hante.meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Thanks, 6 patches applied to wireless-drivers-next.git:

10d096f708e8 brcmfmac: fix skb priority handling
d922dfa372ed brcmfmac: revise SDIO error message in brcmf_sdio_drivestrengthinit
cb39288fd6bb brcmfmac: use ndev->needed_headroom to reserve additional header space
43819926eda5 brcmfmac: add support for the PCIE devices 43525 and 43465
98aff6c005e3 brcmfmac: change rx_seq check log from error print to debug print
2a7344510286 brcm80211: update maintainers email addresses

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9154099/

