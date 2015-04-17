Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55755 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbDQGd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Apr 2015 02:33:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix error handling in pci_probe
References: <1428670887-7533-1-git-send-email-michal.kazior@tieto.com>
Date: Fri, 17 Apr 2015 09:33:21 +0300
In-Reply-To: <1428670887-7533-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Fri, 10 Apr 2015 13:01:27 +0000")
Message-ID: <87vbgv4632.fsf@kamboji.qca.qualcomm.com> (sfid-20150417_083332_979489_A1770C9D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> If chip_id wasn't recognized clean up code wasn't
> executed properly. It would skip freeing memory
> causing a leak and irqs causing possibly MSI
> warning splats later or even kernel crashes.
>
> Fixes: 1a7fecb766c8 ("ath10k: reset chip before reading chip_id in probe")
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
