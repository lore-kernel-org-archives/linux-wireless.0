Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46360 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913Ab1DDSPX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Apr 2011 14:15:23 -0400
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] wl1251: Prepare for idle mode support
References: <1301904298-4725-1-git-send-email-jhnikula@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 04 Apr 2011 21:15:21 +0300
In-Reply-To: <1301904298-4725-1-git-send-email-jhnikula@gmail.com> (Jarkko Nikula's message of "Mon\,  4 Apr 2011 11\:04\:57 +0300")
Message-ID: <87sjtxrih2.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jarkko Nikula <jhnikula@gmail.com> writes:

> RFC for WL1251 idle mode support brought a few issues that are worth to
> update before adding the idle mode support.
>
> Since the idle mode can reuse the code that is now used in Power Save Mode
> (PSM), the flag psm in struct wl1251 is changed to variable station_mode
> to be able to distinguish between PSM and idle modes.
>
> As the station mode is different than the power power save mode command
> that is sent to chip, the enum wl1251_cmd_ps_mod values are used only when
> communicating with the chip and new enum wl1251_station_mode values are used
> inside the driver.
>
> Confusing comment about psm and elp relation is removed since the PSM is
> actually activated by putting the chip into Entreme Low Power (ELP) mode.

This is perfect now, thank you for your patience.

> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
