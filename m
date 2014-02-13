Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45106 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBMXaR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 18:30:17 -0500
Date: Thu, 13 Feb 2014 18:23:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [3.14 FIX][PATCH] bcma: gpio: register all 32 GPIOs
Message-ID: <20140213232346.GK22203@tuxdriver.com> (sfid-20140214_003027_217530_DB48D17B)
References: <1392311186-7805-1-git-send-email-zajec5@gmail.com>
 <CACna6rwDpJ0ArTHGQfq-HNDo3ZAVU4wWuRa6_Ui+ZV+6o+K7Mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACna6rwDpJ0ArTHGQfq-HNDo3ZAVU4wWuRa6_Ui+ZV+6o+K7Mw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 09:04:24PM +0100, Rafał Miłecki wrote:
> 2014-02-13 18:06 GMT+01:00 Rafał Miłecki <zajec5@gmail.com>:
> > Broadcom boards have 32 GPIOs (not 16) and these higher ones are
> > actually used on some devices (for buttons, reset of WiFi devices).
> 
> I forgot about one important thing. This patch is based on top of
> changes from 3.14-rc1.
> 
> John: do you plan to pull David's net.git tree into your wireless.git?

No.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
