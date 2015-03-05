Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39421 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbbCEMNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 07:13:19 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH next] bcma: move internal function declarations to private header
References: <1425475492-16259-1-git-send-email-zajec5@gmail.com>
Date: Thu, 05 Mar 2015 14:13:13 +0200
In-Reply-To: <1425475492-16259-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 4 Mar 2015
 14:24:52 +0100")
Message-ID: <87a8zr63s6.fsf@kamboji.qca.qualcomm.com> (sfid-20150305_131328_631752_7EB3AB35)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> These functions are not exported nor used anywhere, so there is no
> reason to put them in public headers.
> Also drop unused bcma_chipco_(suspend|resume).
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied to wireless-drivers-next.git.

-- 
Kalle Valo
