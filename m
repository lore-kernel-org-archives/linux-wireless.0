Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42187 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbbJUH5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Oct 2015 03:57:30 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/11] brcmfmac: expose device memory to devcoredump subsystem
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1444329201-3696-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20151021075729.F2A5C1410C1@smtp.codeaurora.org> (sfid-20151021_095733_381519_072B48E3)
Date: Wed, 21 Oct 2015 07:57:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Upon PSM watchdog event received from firmware the driver will obtain
> a memory snapshot of the device and expose it to user-space through
> the devcoredump framework. This will trigger a uevent.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 11 patches applied to wireless-drivers-next.git:

ff4445a8502c brcmfmac: expose device memory to devcoredump subsystem
185f0eb0b5fa brcmfmac: Fix race condition between USB probe/load and disconnect.
4a3462843f9f brcmfmac: rename firmware_path to alternative_fw_path
43569bfaf6ed brcmfmac: remove conversational comment
2b76acdbc043 brcmfmac: Rework p2p attach, use single method for p2p dev creation.
124d517211e4 brcmfmac: Fix station info rate information.
cae355dc90db brcmfmac: Add RSSI information to get_station.
bf2a7e0499b9 brcmfmac: Add dump_station support to cfg80221 ops.
c443e169577c brcmfmac: Move brcmf_c_preinit_dcmds prototype to correct file.
54b499d9ad10 brcmfmac: Remove unused state AP creating.
92121e69de8a brcmfmac: Properly set carrier state of netdev.

Kalle Valo
