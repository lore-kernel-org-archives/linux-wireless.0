Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55236 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbbFOKKX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 06:10:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [1/7] brcmfmac: Check if firmware supports p2p
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1433974343-16982-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Pontus Fuchs <pontusf@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150615101022.23F92140C1F@smtp.codeaurora.org> (sfid-20150615_121026_819809_F717E6F5)
Date: Mon, 15 Jun 2015 10:10:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Pontus Fuchs <pontusf@broadcom.com>
> 
> Add a feature flag to reflect the firmware's p2p capability.
> 
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Signed-off-by: Pontus Fuchs <pontusf@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 7 patches applied to wireless-drivers-next.git:

2b560d7148eb brcmfmac: Check if firmware supports p2p
2e5f66fe9593 brcmfmac: Build wiphy mode and interface combinations dynamically
1f0dc59a6de9 brcmfmac: rework .get_station() callback
5768f31e4e75 brcmfmac: have sdio return -EIO when device communication is not possible
f37d69a4babc brcmfmac: free ifp for non-netdev interface in p2p module
55479df8840d brcmfmac: move p2p attach/detach functions
f7a40873d2fa brcmfmac: assure p2pdev is unregistered upon driver unload

Kalle Valo
