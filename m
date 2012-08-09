Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:40626 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557Ab2HIS0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:26:08 -0400
From: Marek Vasut <marex@denx.de>
To: Joseph Honold <mozzwald@gmail.com>
Subject: Re: Palm T|X Libertas Wifi problems Kernel 3.4.7 stable
Date: Thu, 9 Aug 2012 20:26:03 +0200
Cc: linux-wireless@vger.kernel.org
References: <CALSu_YrXF0iO0=+drmUzatGZUYkMxczF_J2Xw_CNqEY3fxJ5Bg@mail.gmail.com>
In-Reply-To: <CALSu_YrXF0iO0=+drmUzatGZUYkMxczF_J2Xw_CNqEY3fxJ5Bg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201208092026.03430.marex@denx.de> (sfid-20120809_202613_860014_F76632FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Joseph Honold,

> I am trying to get wirless working on the Palm T|X (arm pxa270 cpu) with
> the 3.4.7 stable kernel using the cocoboot bootloader app for PalmOS. I
> have extracted the Libertas firmware with cocoboot

There's official 5.x.x firmware for 88w8381 in linux-firmware, use that. V4 FW 
supplied by Palm isn't supported properly.

> and placed it in the
> /lib/firmware dir.The kernel is booting fine to a debian squeeze rootfs,
> the pxa2xx_pcmcia, libertas, and libertas_cs modules load with no errors
> (as long as I do a wifi scan in PalmOS before booting linux). When I scan
> with iwlist I get no results. Here is a snippet of libertas debug messages.
> Does anyone have a suggestion of what I could try to get it working? I can
> provide more info if needed.
[...]

Best regards,
Marek Vasut
