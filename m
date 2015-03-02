Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:32948 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbbCBPAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 10:00:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH V3 1/4] bcma: add helpers bringing PCIe hosted bus up / down
References: <1423409504-16435-1-git-send-email-zajec5@gmail.com>
	<1423411910-22399-1-git-send-email-zajec5@gmail.com>
Date: Mon, 02 Mar 2015 17:00:24 +0200
In-Reply-To: <1423411910-22399-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 8 Feb 2015
 17:11:47 +0100")
Message-ID: <878uffbg1j.fsf@kamboji.qca.qualcomm.com> (sfid-20150302_160040_379595_E5E238E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Bringing PCIe hosted bus up requires operating on host-related core.
> Since we plan to support PCIe Gen 2 devices we should provide a helper
> picking the correct one (PCIE or PCIE2).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, all four patches applied.

-- 
Kalle Valo
