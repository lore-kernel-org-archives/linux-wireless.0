Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:63073 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752018AbbALLxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 06:53:32 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix DMA burst size
References: <1419834066-11802-1-git-send-email-sujith@msujith.org>
Date: Mon, 12 Jan 2015 13:53:20 +0200
In-Reply-To: <1419834066-11802-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 29 Dec 2014 11:51:06 +0530")
Message-ID: <87lhl8dxlb.fsf@kamboji.qca.qualcomm.com> (sfid-20150112_125342_025520_35FD2C9F)
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

Thanks, applied.

-- 
Kalle Valo
