Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36324 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752659Ab3LJPtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Dec 2013 10:49:33 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Luciano Coelho <luca@coelho.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, freemangordon@abv.bg,
	aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
	joni.lapilainen@gmail.com,
	Johannes Berg <johannes@sipsolutions.net>,
	Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting permanent mac address
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
	<1386494714-21070-16-git-send-email-pali.rohar@gmail.com>
Date: Tue, 10 Dec 2013 17:49:23 +0200
In-Reply-To: <1386494714-21070-16-git-send-email-pali.rohar@gmail.com>
 ("Pali
	=?utf-8?Q?Roh=C3=A1r=22's?= message of "Sun, 8 Dec 2013 10:25:13 +0100")
Message-ID: <87txegpuyk.fsf@purkki.adurom.net> (sfid-20131210_165039_608683_CFCB9C60)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár <pali.rohar@gmail.com> writes:

> Driver wl1251 generating mac address randomly at startup and there is no way to
> set permanent mac address via SET_IEEE80211_PERM_ADDR. This patch export sysfs
> file which can set permanent mac address by userspace helper program. Patch is
> needed for devices which do not store mac address in internal wl1251 eeprom.
>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

We have ioctl() command for setting the mac address.

-- 
Kalle Valo
