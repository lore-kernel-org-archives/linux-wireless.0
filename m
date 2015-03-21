Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53479 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbbCUGhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2015 02:37:31 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [for-4.0] brcmfmac: disable MBSS feature for BCM43362
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1426886313-2936-1-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150321063730.43D601413C1@smtp.codeaurora.org> (sfid-20150321_073735_292819_94757276)
Date: Sat, 21 Mar 2015 06:37:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> The BCM43362 firmware falsely reports it is capable of providing
> MBSS. As a result AP mode no longer works for this device. Therefor
> disable MBSS in the driver for this chipset.
> 
> Cc: stable@vger.kernel.org # 3.19.y
> Reported-by: Jorg Krause <jkrause@posteo.de>
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, applied to wireless-drivers.git.

Kalle Valo
