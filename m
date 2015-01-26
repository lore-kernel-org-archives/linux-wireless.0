Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59017 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbbAZG6Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 01:58:25 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2 1/2] bcma: add empty PCIe hostmode functions if support is disabled
References: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
	<1422190968-14422-1-git-send-email-zajec5@gmail.com>
Date: Mon, 26 Jan 2015 08:58:19 +0200
In-Reply-To: <1422190968-14422-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 25 Jan 2015
 14:02:48 +0100")
Message-ID: <87iofugh9w.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_075835_345025_E8FF6C7F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This allows us to drop some #ifdef magic (mess).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> V2: Return false in bcma_core_pci_is_in_hostmode
>     Don't (accidentally) modify bcma_host_soc_register_driver

It would be far more reliable if you resend the whole patchset instead
of resending invidiviual patches within the set. Otherwise the chances
are that I apply the wrong version.

-- 
Kalle Valo
