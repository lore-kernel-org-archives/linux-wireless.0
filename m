Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57373 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbbFHLdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 07:33:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	<stable@vger.kernel.org>
Subject: Re: [PATCH FIX] b43: fix support for 14e4:4321 PCI dev with BCM4321 chipset
References: <1433623559-25433-1-git-send-email-zajec5@gmail.com>
Date: Mon, 08 Jun 2015 14:33:03 +0300
In-Reply-To: <1433623559-25433-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sat, 6 Jun 2015
 22:45:59 +0200")
Message-ID: <87r3pmjuz4.fsf@kamboji.qca.qualcomm.com> (sfid-20150608_133312_477434_5FC84A58)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> It seems Broadcom released two devices with conflicting device id. There
> are for sure 14e4:4321 PCI devices with BCM4321 (N-PHY) chipset, they
> can be found in routers, e.g. Netgear WNR834Bv2. However, according to
> Broadcom public sources 0x4321 is also used for 5 GHz BCM4306 (G-PHY).
> It's unsure if they meant PCI device id, or "virtual" id (from SPROM).
> To distinguish these devices lets check PHY type (G vs. N).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: <stable@vger.kernel.org> # 3.16+

Thanks, applied manually.

-- 
Kalle Valo
