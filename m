Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42940 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375AbbJ1TGq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Oct 2015 15:06:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH 1/2] ssb: move functions specific to SoC hosted bus to separated file
References: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
Date: Wed, 28 Oct 2015 21:06:39 +0200
In-Reply-To: <1445797963-5968-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 25 Oct 2015
 19:32:42 +0100")
Message-ID: <87ziz2sthc.fsf@kamboji.qca.qualcomm.com> (sfid-20151028_200649_401790_E5102D36)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> This cleans main.c a bit and will allow us to compile SoC related code
> conditionally in the future.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Both patches applied manually to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
