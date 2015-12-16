Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbLPOhb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 09:37:31 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
	Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] ssb: pick SoC invariants code from MIPS BCM47xx arch
References: <1449700611-6952-1-git-send-email-zajec5@gmail.com>
Date: Wed, 16 Dec 2015 16:37:22 +0200
In-Reply-To: <1449700611-6952-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 9 Dec 2015
 23:36:51 +0100")
Message-ID: <871tamfoil.fsf@kamboji.qca.qualcomm.com> (sfid-20151216_153734_224409_ED146316)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> There is code in ssb fetching "invariants" that is basically a set of
> board specific data. Every host requires its own implementation of
> reading function. In ssb we have support for PCI, PCMCIA & SDIO.
> For some (historical?) reason code reading "invariants" for SoC was
> placed in arch code and provided by a callback. This is not needed
> nowadays, so lets move that into ssb. This way we keep all "invariants"
> functions in a single module making code cleaner.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
