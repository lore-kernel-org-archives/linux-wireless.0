Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:45176 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755779AbbAWTtw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:49:52 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH V2] bcma: use standard bus scanning during early register
References: <1421442493-32133-1-git-send-email-zajec5@gmail.com>
	<1421652630-26665-1-git-send-email-zajec5@gmail.com>
Date: Fri, 23 Jan 2015 21:49:47 +0200
In-Reply-To: <1421652630-26665-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Mon, 19 Jan 2015
 08:30:30 +0100")
Message-ID: <87vbjxjmzo.fsf@kamboji.qca.qualcomm.com> (sfid-20150123_204955_938318_3EC69D0A)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Starting with kernel 3.19-rc1 early registration of bcma on MIPS is done
> a bit later, with memory allocator available. This allows us to simplify
> code by using standard bus scanning method.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually to wireless-drivers-next.git.

-- 
Kalle Valo
