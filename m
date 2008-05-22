Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.186]:24219 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757229AbYEVQuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 12:50:44 -0400
Received: by rn-out-0910.google.com with SMTP id k40so146512rnd.17
        for <linux-wireless@vger.kernel.org>; Thu, 22 May 2008 09:50:42 -0700 (PDT)
Message-ID: <69e28c910805220950q59d3ff05x19f4facef8be91b0@mail.gmail.com> (sfid-20080522_185050_038537_1850050F)
Date: Thu, 22 May 2008 18:50:42 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Hauke Mehrtens" <hauke@hauke-m.de>
Subject: Re: b43 lots of 43-phy0 ERROR: PHY transmission error
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Michael Buesch" <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <48359AF2.4070802@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48359AF2.4070802@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 22, 2008 at 6:10 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> I am using Ubuntu 8.04 for AMD64 with a vanilla kernel 2.6.25.3 and a
> Broadcom Corporation BCM94311MCG wlan mini-PCI (rev 01) with firmware
> version 410.2160 and the driver out of kernel 2.6.25.3.
>
> When I am connected to some Access Points at University without wireless
> encryption I get lots of error like this after some time (5 to 30 min):
> [  182.179788] b43-phy0 ERROR: PHY transmission error
> [  187.956923] printk: 28 messages suppressed.
>
> With this error Network Manager says my connection is still up, but I
> cant send data through the wireless LAN. The only way to get the
> wireless LAN working again to rmmod b43 and insmod it again.
> At some Access Points at University everything work fine and at home I
> have no problems. With an earlier version of the b43 driver (~January
> compat-wireless) I had no problems at the Access Points, that doesn't
> work now.
>
> These logs where taken at one place and I have rmmoded the driver some
> times.
> dmesg           http://www.hauke-m.de/fileadmin/b43/dmesg-2008-05-16
> iwconfig        http://www.hauke-m.de/fileadmin/b43/iwconfig-2008-05-16
> iwlist          http://www.hauke-m.de/fileadmin/b43/iwlist-2008-05-16
>
> --
> Hauke Mehrtens
>
>
>

I have also seen the error numerous times, but it appears to only come
up with v4.150 firmware, and not v4.80.

Devs: can we update fwcutter to allow cutting from v4.150.10.5.1 or
v4.150.10.5.2? This might be a bug in the original v4.150.10.5
firmware.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
