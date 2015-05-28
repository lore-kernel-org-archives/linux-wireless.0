Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55348 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbE1IvA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2015 04:51:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: simplify check finding NVRAM v1 device path
References: <1432112468-24092-1-git-send-email-zajec5@gmail.com>
Date: Thu, 28 May 2015 11:50:53 +0300
In-Reply-To: <1432112468-24092-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Wed, 20 May 2015
 11:01:08 +0200")
Message-ID: <87617dytjm.fsf@kamboji.qca.qualcomm.com> (sfid-20150528_105105_529244_F393D0FC)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> With a simple use of snprintf and small buffer we can compare NVRAM
> entry value with a full string. This way we avoid checking random chars
> at magic offsets.
> Tested on BCM43602 with NVRAM hacked to use v1 format.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Thanks, applied manually.

-- 
Kalle Valo
