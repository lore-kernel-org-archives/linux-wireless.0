Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53126 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbCTHK0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 03:10:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] bcma: gpio: use predictable base for all BCM47XX buses
References: <1426444994-21506-1-git-send-email-zajec5@gmail.com>
Date: Fri, 20 Mar 2015 09:10:20 +0200
In-Reply-To: <1426444994-21506-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 15 Mar 2015
 19:43:14 +0100")
Message-ID: <877fuci1pf.fsf@kamboji.qca.qualcomm.com> (sfid-20150320_081029_067394_D904B8EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Some BCM47XX SoC routers have LEDs connected to extra PCIe bcma buses.
> Handling them in arch code requires predictable GPIO numbers.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually to wireless-drivers-next.git.

(I really wish kernel.org admins would fix the annoying UTF-8 bug in
patchwork.)

-- 
Kalle Valo
