Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h5.dl5rb.org.uk ([81.2.74.5]:60556 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751787Ab1G0UHu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jul 2011 16:07:50 -0400
Date: Wed, 27 Jul 2011 21:06:57 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, jonas.gorski@gmail.com,
	zajec5@gmail.com, mb@bu3sch.de, george@znau.edu.ua,
	arend@broadcom.com, b43-dev@lists.infradead.org,
	bernhardloos@googlemail.com, arnd@arndb.de,
	julian.calaby@gmail.com, sshtylyov@mvista.com
Subject: Re: [PATCH v3 00/11] bcma: add support for embedded devices like
 bcm4716
Message-ID: <20110727200657.GA15028@linux-mips.org> (sfid-20110727_220753_670771_4E37DC34)
References: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1311376815-15755-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 23, 2011 at 01:20:04AM +0200, Hauke Mehrtens wrote:

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
> @John could you please merge this into wireless-testing. I hope Ralf is 
> fine with it when some MIPS bits will go through wireless. This will 
> make it much easier for Linus to merge wireless-testing and the mips 
> tree together as there are many other changes for bcma in wireless-
> testing.

John, if you want to merge the MIPS bits through the wireless tree, feel
free to:

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
