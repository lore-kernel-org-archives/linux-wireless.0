Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37060 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0LUPT6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Dec 2010 10:19:58 -0500
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/7] wl1251: remove unnecessary import
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
	<1292893316-26694-2-git-send-email-hauke@hauke-m.de>
From: Kalle Valo <kvalo@adurom.com>
Date: Tue, 21 Dec 2010 17:19:56 +0200
In-Reply-To: <1292893316-26694-2-git-send-email-hauke@hauke-m.de> (Hauke Mehrtens's message of "Tue\, 21 Dec 2010 02\:01\:50 +0100")
Message-ID: <87ei9bgnkz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hauke Mehrtens <hauke@hauke-m.de> writes:

> No function declared in gpio.h is used here.

That's right, thanks.

> CC: Kalle Valo <kvalo@adurom.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
