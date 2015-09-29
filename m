Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36964 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835AbbI2H50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:57:26 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/16] brcmfmac: Fix exception handling.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1442606899-31872-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150929075725.D0D56140F8E@smtp.codeaurora.org> (sfid-20150929_095749_006702_FE47D49A)
Date: Tue, 29 Sep 2015 07:57:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> In some exception situations the ifp->vif was not properly assigned
> which could result in crash.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 16 patches applied to wireless-drivers-next.git:

2b5d348ee786 brcmfmac: Fix exception handling.
e3c92cb2eea3 brcmfmac: Add support for the BCM4350 PCIE device.
60dc35ef9ffd brcmfmac: Fix set and get tx-power functions.
6ea696eb4e26 brcmfmac: Only assign primary netdev to if2bss array.
ae7c03f68ee2 brcmfmac: Inform p2p module about p2pon through API
9f64df940cfe brcmfmac: Fix bug in flowring management.
43e55a2a1cf0 brcmfmac: Make p2pon module param always available.
178e9ef9b6c6 brcmfmac: Workaround in change vif for wpa_supplicant support.
9831bcb987df brcmfmac: Deleting of p2p device is leaking memory.
d1bb34c128f5 brcmfmac: Only handle p2p_stop_device if vif is valid
35a3cbcc49b5 brcmfmac: Fix p2p bug for older firmwares.
8268c2011d25 brcmfmac: Add module parameter to disable features.
a2044d91d9d2 brcmfmac: Fix race condition bug when deleting p2p interface.
55acca90da52 brcmfmac: Add support for the BCM4365 and BCM4366 PCIE devices.
cb8dc71f516a brcmfmac: Fix TDLS setup by properly handling p2p noif.
29b93c0e3c38 brcmfmac: Accept events when TDLS is used in combination with p2p.

Kalle Valo
