Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37170 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820AbbI2ICc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 04:02:32 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/3] ssb: unexport ssb_bus_pcibus_register
References: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
Date: Tue, 29 Sep 2015 11:02:25 +0300
In-Reply-To: <1442821640-14582-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Mon, 21 Sep 2015
 09:47:18 +0200")
Message-ID: <874mid8xgu.fsf@kamboji.qca.qualcomm.com> (sfid-20150929_100237_288651_DD412646)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> It isn't used anywhere out of ssb code and we don't (plan to) build
> pcihost_wrapper.c as a separated module.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, all three patches manually applied.

-- 
Kalle Valo
