Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40488 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbbKZL57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 06:57:59 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/9] brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1446147199-21671-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20151126115754.97089141133@smtp.codeaurora.org> (sfid-20151126_125802_101816_C8337EBE)
Date: Thu, 26 Nov 2015 11:57:54 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 9 patches applied to wireless-drivers-next.git:

2aff030355b5 brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
c9c0043894cf brcmfmac: Simplify and fix usage of brcmf_ifname.
31fa86cb342b brcmfmac: Remove unnecessary check from start_xmit.
da402c56bc91 brcmfmac: Remove unncessary variable irq_requested.
dc1a272ec440 brcmfmac: Disable runtime pm for USB.
8abffd8173a1 brcmfmac: Add RSDB support.
37a869ec8593 brcmfmac: Use consistent naming for bsscfgidx.
c2a43a6ba5e5 brcmfmac: Use new methods for pcie Power Management.
aeb64225aa8e brcmfmac: Add wowl wake indication report.

Kalle Valo
