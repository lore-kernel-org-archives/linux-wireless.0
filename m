Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:58457 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab0BNRpZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 12:45:25 -0500
Date: Sun, 14 Feb 2010 18:44:34 +0100
From: Frederic Leroy <fredo@starox.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
Message-ID: <20100214184434.119c8694@houba>
In-Reply-To: <4B78312A.7060308@lwfinger.net>
References: <4B38A298.7070103@googlemail.com>
	<1262037590.16627.99.camel@localhost.localdomain>
	<3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>
	<20100213234456.5ae49b67@houba>
	<20100214004010.GB18815@tuxdriver.com>
	<20100214131810.1a8b49ac@houba>
	<4B78312A.7060308@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Sun, 14 Feb 2010 11:21:46 -0600,
Larry Finger <Larry.Finger@lwfinger.net> a écrit :
> [...]
> * Make certain the driver in staging works in its present form.

Currently, I use it currently and seems stable.

> * Prepare a patch to eliminate the unused branches of if(0) and if(1)
> [...]
> After the staging driver is leaner and cleaner, then you can start on
> the port. As the RTL8192SU is a USB device, you may want to start
> with rtl8187 rather than rtl8180, which is a PCI device. Once you
> reach the point of getting a driver that has minimal functionality,
> you can use the USB capture routines to compare your version with the
> one that works.
> 
> Writing a new driver is a very involved process as I have found with
> the RTL8187SE. In fact, my first two attempts failed, in large part
> because I did not do the steps above. The current attempt looks more
> promising as it has successfully read the EEPROM and is about 1000
> register read/write steps toward getting the device initialized.

Thanks for your wise advice Larry.
I will follow it.

-- 
Frédéric Leroy
