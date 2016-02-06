Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53133 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFLgk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:36:40 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/2] bcma: use _PMU_ in all names of PMU registers
References: <1453189526-24689-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:36:33 +0200
In-Reply-To: <1453189526-24689-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Tue, 19 Jan 2016
 08:45:25 +0100")
Message-ID: <878u2yvzni.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_123642_772886_39317C25)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> PMU (Power Management Unit) seems to be a separated piece of hardware,
> just accessed using ChipCommon core registers. In recent Broadcom
> chipsets PMU is not bounded to CC but available as separated core.
>
> To make code cleaner & easier to review (for a correct R/W access) use
> clearer names.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied both patches to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
