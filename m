Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43660 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbbCCN4m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 08:56:42 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] bcma: gpio: enable GPIO IRQ domain on BCM5301X
References: <1424429345-20128-1-git-send-email-zajec5@gmail.com>
Date: Tue, 03 Mar 2015 15:56:36 +0200
In-Reply-To: <1424429345-20128-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 20 Feb 2015
 11:49:05 +0100")
Message-ID: <87sidm89rf.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_145647_087741_5F2F91E3)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Just like on BCM47XX arch, BCM5301X also has ChipCommon with IRQ for
> GPIOs. Now we have interrupts working on BCM5301X we can finally make
> use of it. This has been successfully tested on 5 different devices
> (Buffalo, Luxul, Netgear).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
