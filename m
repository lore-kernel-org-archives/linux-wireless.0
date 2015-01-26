Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:59095 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbbAZHEj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Jan 2015 02:04:39 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] b43: AC-PHY: prepare place for developing new PHY support
References: <1422205297-24767-1-git-send-email-zajec5@gmail.com>
Date: Mon, 26 Jan 2015 09:04:33 +0200
In-Reply-To: <1422205297-24767-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 25 Jan 2015
 18:01:37 +0100")
Message-ID: <87egqiggzi.fsf@kamboji.qca.qualcomm.com> (sfid-20150126_080845_781582_E8429AFB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> There are new (not anymore?) Broadcom 802.11ac wireless cards based on
> chipsets like BCM4352 and BCM4360. They use a new PHY type (called
> simply AC) that will require new specific code.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
>
> Kalle: as this commit & Kconfig say, this is just a beginning of new
> PHY type support. In the past we used development model this patch
> follows. Code for new PHY was added patch by patch. Adding everything
> at once would require a huge patchset & development behing the doors.
> Also sending small patches allows better review of changes & should
> result in a better code quality. Let me know if there are any
> problems.

Sounds good to me. Just keep dependency to BROKEN until it's usable and
make sure that the code compiles after every patch.

-- 
Kalle Valo
