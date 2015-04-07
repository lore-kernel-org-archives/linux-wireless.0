Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33448 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbbDGRSe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 13:18:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Michael =?utf-8?Q?B=C3=BCsch?= <m@bues.ch>,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] ssb: add delay after PCI reset to fix SoC reboots
References: <1428251967-18066-1-git-send-email-zajec5@gmail.com>
Date: Tue, 07 Apr 2015 20:18:27 +0300
In-Reply-To: <1428251967-18066-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 5 Apr 2015
 18:39:27 +0200")
Message-ID: <878ue3x3fg.fsf@kamboji.qca.qualcomm.com> (sfid-20150407_191838_604602_584B200B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Kalle: this bug is there since ever, I guess this patch can be queued for next.

Thanks, applied.

-- 
Kalle Valo
