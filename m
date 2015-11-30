Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37146 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbbK3MsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 07:48:17 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/11] brcmfmac: Cleanup ssid storage.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1448447567-12189-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20151130124816.E0B9B14089C@smtp.codeaurora.org> (sfid-20151130_134820_666008_DE20ACB1)
Date: Mon, 30 Nov 2015 12:48:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> From: Hante Meuleman <meuleman@broadcom.com>
> 
> SSIDs used for connect and p2p got stored, but never used.
> 
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 10 patches applied to wireless-drivers-next.git:

e9a6ca825eb7 brcmfmac: Cleanup ssid storage.
21000b3f3da4 brcmfmac: Return actual error by fwil.
6a23863eaa51 brcmfmac: Change error print on wlan0 existence.
64d66c30c37e brcmfmac: no retries on rxglom superframe errors
c495810624ef brcmfmac: Remove redundant parameter action from scan.
1119e23edf25 brcmfmac: Cleanup roaming configuration.
7bf65aa9ad3f brcmfmac: Add beamforming support.
b4fd63c608a2 brcmfmac: assure net_ratelimit() is declared before use
46d703a77539 brcmfmac: Unify methods to define and map firmware files.
5536f20a1c43 brcmfmac: Fix double free on exception at module load.

Kalle Valo
