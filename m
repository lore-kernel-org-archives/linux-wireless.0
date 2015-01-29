Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:57194 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbbA2Is2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 03:48:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] bcma: fix watchdog on some ARM chipsets
References: <1422055401-15029-1-git-send-email-zajec5@gmail.com>
Date: Thu, 29 Jan 2015 10:48:23 +0200
In-Reply-To: <1422055401-15029-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sat, 24 Jan 2015
 00:23:21 +0100")
Message-ID: <874mra3rc8.fsf@kamboji.qca.qualcomm.com> (sfid-20150129_094832_032873_AF38E825)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> These chipsets don't need changing clock mode.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Rafał, as I need to apply your patches manually until patchwork is fixed
I'm not going to send the usual "Thanks, applied" email from now on.
It's just too much work for me. But I will mark your patch as Accepted
in patchwork. I hope this is ok.

-- 
Kalle Valo
