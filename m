Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:55311 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab0FETDD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Jun 2010 15:03:03 -0400
Date: Sat, 5 Jun 2010 20:50:15 +0200
From: Frederic Leroy <fredo@starox.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>, Greg KH <greg@kroah.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Conversion of driver for Realtek 8192SU
Message-ID: <20100605205015.65979235@devel>
In-Reply-To: <4BFE9A22.5040005@lwfinger.net>
References: <4BFE9A22.5040005@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Thu, 27 May 2010 11:13:22 -0500,
Larry Finger <Larry.Finger@lwfinger.net> a écrit :

> I am in the process of converting the driver contained in the file
> RTL8192SU_usb_linux_v2.6.0006.20100511.zip obtained from the Realtek
> site. This driver is used for the following USB IDs:
> 
> Realtek (0x0bda)  0x8171, 0x8172, 0x8173, 0x8174, 0x8712,
> 0x8713,
> [...]
> My test device is a D-Link DWA-130 (14b2:3300). The Realtek driver
> compiles cleanly and works as-is for this device on i386 architecture;

I own a Trendnet TEW-649UB (usb ids : 0bda:8172).
I got the staging driver working only once. Since then, I found that the
function which sets the channel didn't work.
The 20100511 driver has the same behaviour at first sight, looking at
wireshark trace.

> My initial plan is to modify this driver code for inclusion in
> drivers/staging. The above list includes some, but not all, of the IDs
> in the driver currently in drivers/staging/rtl8192su. I will likely
> put this in as drivers/staging/rtl8712u, which is the name used in
> the code, and remove the duplicate IDs from rtl8192su. Once this step
> is done, I will then work at modifying it to use mac80211 so that it
> can go into mainline.

Some work has been made in the staging driver. Can it be a better
start ?

Have you a repository with your work ? I would like to test it again my
device and if possible join our effort.

-- 
Frédéric Leroy
