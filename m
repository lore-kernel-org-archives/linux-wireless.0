Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51214 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbcCGMmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:42:32 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH 1/3] bcma: drop unneeded fields from bcma_pflash struct
References: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
Date: Mon, 07 Mar 2016 14:42:24 +0200
In-Reply-To: <1455268545-11667-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 12 Feb 2016
 10:15:43 +0100")
Message-ID: <87lh5utq6n.fsf@kamboji.qca.qualcomm.com> (sfid-20160307_134235_154904_F80679D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Most of info stored in this struct wasn't really used anywhere as we put
> all that data in platform data & resource as well.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next, thanks.

-- 
Kalle Valo
