Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay3.ukrpost.ua ([82.207.79.23]:52357 "EHLO relay3.ukrpost.ua"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab1EGSB7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 14:01:59 -0400
Received: from mail.academy.zt.ua ([82.207.120.245])
	by relay3.ukrpost.ua with esmtp (Exim 4.75)
	(envelope-from <prvs=110837b279=george@znau.edu.ua>)
	id 1QIlgf-0000Tj-Od
	for linux-wireless@vger.kernel.org; Sat, 07 May 2011 20:53:06 +0300
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v12.0.0)
	with ESMTP id md50000002737.msg
	for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 20:51:49 +0300
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus
	driver
From: George Kashperko <george@znau.edu.ua>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4DC5805C.2010202@hauke-m.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	 <4DC56FB9.5000208@hauke-m.de>
	 <BANLkTi=FfjK7obq0hj4TjYZc-GgzTuUC6g@mail.gmail.com>
	 <4DC57425.30206@hauke-m.de>
	 <BANLkTikTarvigU-xZNZikhLyvUWse448Tg@mail.gmail.com>
	 <4DC5805C.2010202@hauke-m.de>
Content-Type: text/plain
Date: Sat, 07 May 2011 20:45:24 +0300
Message-Id: <1304790324.13983.5.camel@dev.znau.edu.ua> (sfid-20110507_200202_522183_D0BA9E01)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> Some of the embedded devices also have a USB core on the BCMA bus and a
> pci(e) host controller to connect other pci(e) devices. As most of the
> patches for ssb came from the wireless guys and I do not thing this will
> be different for bcma, I thing the wireless mailing list is the correct
> place.
> 
> @George what is the status of adding support for the embedded devices?
Haven't been looking into Rafal's code closely yet. I'm working on
another solution suitable for SSB, AXI and hopefully UBUS as well but I
don't ready to publish it yet.

Regarding ethernet driver, still no feedback on GPL-friendly licensing
possibility for the code from Broadcom.

Have nice day,
George


