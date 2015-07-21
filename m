Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33096 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850AbbGUOH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2015 10:07:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Arnd Bergmann <arnd@arndb.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] bcma: populate bus DT subnodes as platform_device-s
References: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
Date: Tue, 21 Jul 2015 17:07:23 +0300
In-Reply-To: <1435504633-20831-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 28 Jun 2015
 17:17:13 +0200")
Message-ID: <871tg1ob8k.fsf@kamboji.qca.qualcomm.com> (sfid-20150721_160739_275382_209815CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Our bus should allow defining children nodes as we may want to specify
> devices attached to the bus. This is required e.g. to specify NAND or
> ChipCommon cores and use bus's address and IRQ mappings.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, manually applied to wireless-drivers-next.git.

-- 
Kalle Valo
