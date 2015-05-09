Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52038 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbbEIN11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 May 2015 09:27:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/10] brcmfmac: use static superset of channels for wiphy bands
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1429035033-14076-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150509132726.836E113FF52@smtp.codeaurora.org> (sfid-20150509_153200_973210_27953CEF)
Date: Sat,  9 May 2015 13:27:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The driver was constructing a list of channels per wiphy band
> by querying the device. This list is not what the hardware is
> able to do as it is already filtered by the country setting in
> the device. As user-space may change the country this would
> require updating the channel list which is not recommended [1].
> This patch introduces a superset of channels. The individual
> channels are disabled appropriately by querying the device.
> 
> [1] http://mid.gmane.org/1426706320.3001.21.camel@sipsolutions.net
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 10 patches applied to wireless-drivers-next.git:

58de92d2f95e brcmfmac: use static superset of channels for wiphy bands
8afe0ece7bfd brcmfmac: update wiphy band information upon updating regulatory domain
28d96e5ee513 brcmfmac: add description for feature flags
7a7a87dc947c brcmfmac: make scheduled scan support conditional
ba5e8665b805 brcmfmac: add support for BCM4324 rev B5 chipset
8b36e98895e1 brcmfmac: process interrupt regardless sdiod state
bdf1340cf20f brcmfmac: fix sdio suspend and resume
67f3b6a3d1ca brcmfmac: add support for BCM4358 PCIe device
27aace2dcc9a brcmfmac: add additional 43602 pcie device id.
c43655345234 brcmfmac: Add support for multiple PCIE devices in nvram.

Kalle Valo
