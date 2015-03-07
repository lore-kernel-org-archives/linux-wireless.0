Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63758 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbbCGIH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2015 03:07:56 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ath10k: fix some pci wake/sleep issues
References: <1425298934-12370-1-git-send-email-michal.kazior@tieto.com>
Date: Sat, 7 Mar 2015 10:07:47 +0200
In-Reply-To: <1425298934-12370-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Mon, 2 Mar 2015 13:22:13 +0100")
Message-ID: <87k2ytz0vg.fsf@kamboji.qca.qualcomm.com> (sfid-20150307_093417_155480_97C2AF1B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> In some cases the device ends up sleeping while
> ath10k didn't expect it to leading to reading
> garbage from registers, e.g. when shared irqs are
> used and the driver is in powered down state.
>
> This effectively makes the device remain awake all
> the time even when all interfaces are down.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
