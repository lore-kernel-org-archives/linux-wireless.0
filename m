Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53233 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbcBFLqM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:46:12 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH] bcma: init serial console directly from ChipCommon code
References: <1453482174-11021-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:46:06 +0200
In-Reply-To: <1453482174-11021-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Fri, 22 Jan 2016
 18:02:54 +0100")
Message-ID: <87ziveukn5.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_124615_581685_5A177E13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> UART is connected to and controlled over ChipCommon core. It doesn't
> have much to do with MIPS core (where we initialize it currently)
> except just existing on embedded systemms. There isn't point of such
> cross-core initialization (and we needed #ifdef anyway) so just handle
> it in ChipCommon.
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
