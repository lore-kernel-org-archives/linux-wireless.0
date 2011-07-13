Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53550 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1GMSr1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 14:47:27 -0400
Date: Wed, 13 Jul 2011 14:33:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-wireless@vger.kernel.org,
	zajec5@gmail.com, linux-mips@linux-mips.org, mb@bu3sch.de,
	george@znau.edu.ua, arend@broadcom.com,
	b43-dev@lists.infradead.org, bernhardloos@googlemail.com,
	arnd@arndb.de, julian.calaby@gmail.com, sshtylyov@mvista.com
Subject: Re: [PATCH 00/11] bcma: add support for embedded devices like bcm4716
Message-ID: <20110713183327.GD27827@tuxdriver.com> (sfid-20110713_204736_769263_B6832815)
References: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1310209563-6405-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 09, 2011 at 01:05:52PM +0200, Hauke Mehrtens wrote:
> This patch series adds support for embedded devices like bcm47xx to 
> bcma. Bcma is used on bcm4716 and bcm4718 SoCs as the system bus and
> replaced ssb used on older devices. With these patches my bcm4716 
> device boots up till it tries to access the flash, because the serial 
> flash chip is unsupported for now, this will be my next task. This adds 
> support for MIPS cores, interrupt configuration and the serial console.
> 
> These patches are not containing all functions needed to get the SoC to 
> fully work and support every feature, but it is a good start.
> These patches are now integrated in OpenWrt for everyone how wants to
> test them.
> 
> This was tested with a BCM4704 device (SoC with ssb bus), a BCM4716 
> device and a pcie wireless card supported by bcma.
> 
> 
> @Rafał: If you are fine with the bcma patches could you please give
> your Signed-off on them.

Rafał, ping?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
