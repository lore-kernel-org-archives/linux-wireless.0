Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45035 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757450AbbJ2TtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2015 15:49:21 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 0/9] brcmfmac: new device support and cleanup
References: <1446147199-21671-1-git-send-email-arend@broadcom.com>
Date: Thu, 29 Oct 2015 21:49:13 +0200
In-Reply-To: <1446147199-21671-1-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Thu, 29 Oct 2015 20:33:10 +0100")
Message-ID: <87h9l9o3pi.fsf@kamboji.qca.qualcomm.com> (sfid-20151029_204925_028182_883E8B6E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> Here a smallish series which hopefully can make it in 4.4 release. The
> highlights are:
>
> * support bcm4359 which can operate in two bands concurrently.
> * disable runtime pm for USB avoiding issues.
> * use generic pm callback in PCIe driver.
> * support wowlan wake indication reporting.
>
> The series is intended for v4.4 and applies to the master branch
> of the wireless-drivers-next repository.
>
> Hante Meuleman (9):
>   brcmfmac: Add support for the BCM4359 11ac RSDB PCIE device.
>   brcmfmac: Simplify and fix usage of brcmf_ifname.
>   brcmfmac: Remove unnecessary check from start_xmit.
>   brcmfmac: Remove unncessary variable irq_requested.
>   brcmfmac: Disable runtime pm for USB.
>   brcmfmac: Add RSDB support.
>   brcmfmac: Use consistent naming for bsscfgidx.
>   brcmfmac: Use new methods for pcie Power Management.
>   brcmfmac: Add wowl wake indication report.

I just tagged a pull request to Dave which I hope to be the last one.
Unless Linus delays the release I doubt these make it to 4.4, sorry.

-- 
Kalle Valo
