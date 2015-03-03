Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49609 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbbCCPFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Mar 2015 10:05:09 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	stable@vger.kernel.org
Subject: Re: [PATCH][FIX][RESEND] b43: fix support for 5 GHz only BCM43228 model
References: <1424103816-10566-1-git-send-email-zajec5@gmail.com>
	<1425313135-28225-1-git-send-email-zajec5@gmail.com>
Date: Tue, 03 Mar 2015 17:05:02 +0200
In-Reply-To: <1425313135-28225-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Mon, 2 Mar 2015
 17:18:55 +0100")
Message-ID: <87k2yy86ld.fsf@kamboji.qca.qualcomm.com> (sfid-20150303_160514_588529_A41DE7C8)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> It was incorrectly detected as 2 GHz device.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> Cc: stable@vger.kernel.org # 3.17+
> ---
> Kalle: can you take it for 3.20, please?

Thanks, applied to wireless-drivers.git.

> RESEND: It seems patchwork didn't catch my patch. Trying again.

Odd, I still don't see it in patchwork. I wonder what caused that?

-- 
Kalle Valo
