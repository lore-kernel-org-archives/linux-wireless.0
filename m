Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f192.google.com ([209.85.211.192]:57975 "EHLO
	mail-yw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbZICWyj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 18:54:39 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Sep 2009 15:54:21 -0700
Message-ID: <43e72e890909031554v1343bcfdu8ed6e23d0b1df832@mail.gmail.com>
Subject: Atheros Linux wireless drivers home page - and two new driver
	projects
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org
Cc: Len Widra <Len.Widra@atheros.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Werner Almesberger <werner@openmoko.org>,
	Stefan Lippers-Hollmann <s.L-H@gmx.de>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Bob Copeland <me@bobcopeland.com>, Greg KH <greg@kroah.com>,
	rshlinux@gmail.com, b_yogesh_snowy@yahoo.com,
	Michael Renzmann <mrenzmann@madwifi-project.org>,
	Stephen Chen <Stephen.Chen@atheros.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Harald Welte <laforge@openmoko.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm pleased to announce the new home page to Atheros Linux wireless drivers:

http://wireless.kernel.org/en/users/Drivers/Atheros

To get updates just subscribe to the wiki. There you will find
information regarding any old legacy Atheros driver and any proper
upstream driver.

I'd like to also take the time to announce two devices for which
support is currently being developed for: ar5523 and ar9271. Both
ar5523 and ar9271 device support is currently being worked on either
by the community or by Atheros itself. Both of these driver projects
will be using th Linux driver project [1] to gain traction. Patches
and development discussions regarding these two drivers prior to
getting upstream into drivers/net/wireless/ will take place on the
Linux driver project mailing list [2]. For direct one-on-one
communication for support and development we will rely on the
#linux-wireless IRC channel on irc.freenode.net. Both devices are USB
but differ greatly, please visit the ar5523 page [2] and the ar9271
page [3] for further device specifics and more information.

The model of development for ar9271 device support is rather new -- we
are not targeting staging, instead we target using the strength of
community development at an extremely early stage, as early as is
possible, even before the device is functional. If we get a device
driver functional prior to meeting upstream requirements then so be it
-- and the driver does gets stuffed into drivers/staging. End goal is
to get it into proper drivers/net/wireless/ but obviously it will not
hurt to get users some device functionality prior to that.

The time of turnaround to getting users supported either through
drivers/staging or drivers/net/wireless/ will ultimately depend on the
resources dedicated to it. Right now I know only Stefan
Lippers-Hollmann is working on ar5523 support and I'm the only one
working on ar9271 support. With your help I am in hopes this will
change soon.

[1] http://www.linuxdriverproject.org/twiki/bin/view
[2] http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
[3] http://wireless.kernel.org/en/users/Drivers/ar5523
[4] http://wireless.kernel.org/en/users/Drivers/ar9271

  Luis
