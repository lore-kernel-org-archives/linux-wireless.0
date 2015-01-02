Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32649 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbbABHlS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2015 02:41:18 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix DMA burst size
References: <1419834066-11802-1-git-send-email-sujith@msujith.org>
Date: Fri, 2 Jan 2015 09:41:08 +0200
In-Reply-To: <1419834066-11802-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 29 Dec 2014 11:51:06 +0530")
Message-ID: <87k3156357.fsf@kamboji.qca.qualcomm.com> (sfid-20150102_084145_313679_6E8162E5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> A value of zero indicates that 128B is the maximum
> DMA request size for read/writes. But PCI cards based
> on AR9880 can support 256B, so enable this for
> the 10.2 firmware.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Did you see any throughput improvements with this?

-- 
Kalle Valo
