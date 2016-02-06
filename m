Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53188 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFLnt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:43:49 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: fix setting primary channel for 80 MHz width
References: <1453304764-11895-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:43:42 +0200
In-Reply-To: <1453304764-11895-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 20 Jan 2016
 16:46:04 +0100")
Message-ID: <874mdmvzbl.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_124420_539641_2504776B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> First of all it changes the way we calculate primary channel offset. If
> we use e.g. 80 MHz channel with primary frequency 5180 MHz (which means
> center frequency is 5210 MHz) it makes sense to calculate primary offset
> as -30 MHz.
> Then it fixes values we compare primary_offset with. We were comparing
> offset in MHz against -2 or 2 which was resulting in picking a wrong
> primary channel.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
