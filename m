Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:55367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab1EHPye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 May 2011 11:54:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
Date: Sun, 8 May 2011 17:54:14 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com> <201105081706.12449.arnd@arndb.de> <BANLkTinujj_E4xPvbXB_AQM-d9BqHRts8Q@mail.gmail.com>
In-Reply-To: <BANLkTinujj_E4xPvbXB_AQM-d9BqHRts8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201105081754.14993.arnd@arndb.de> (sfid-20110508_175439_206644_3B1280BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 08 May 2011 17:25:55 Rafał Miłecki wrote:
> 2011/5/8 Arnd Bergmann <arnd@arndb.de>:
> 
> Arnd, right now I'm loosing a lot of time (I could spent on improving
> bcma or b43) on posting new version of this huge patch with single
> changes. Changes that can easily be introduced later without breaking
> driver, ABI, etc.
> 
> I'll be glad to try your solution later, when we get this patch
> merged. I'll be much easier to play with such a differences then.
> Thanks for sharing this idea.
> 
> Right now I want to focus on some bugs in driver that don't allow it
> being merged.

Ok, then I'd suggest leaving out the device strings for now,
you can always add them at a later point.

	Arnd
