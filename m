Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:64389 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbcGXUQH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jul 2016 16:16:07 -0400
Subject: [PATCH 0/3] staging: wilc1000: Fine-tuning for two function
 implementations
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Glen Lee <glen.lee@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Johnny Kim <johnny.kim@atmel.com>, Leo Kim <leo.kim@atmel.com>,
	Tony Cho <tony.cho@atmel.com>
References: <5307CAA2.8060406@users.sourceforge.net>
 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>
 <530A086E.8010901@users.sourceforge.net>
 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>
 <530A72AA.3000601@users.sourceforge.net>
 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>
 <530B5FB6.6010207@users.sourceforge.net>
 <alpine.DEB.2.10.1402241710370.2074@hadrien>
 <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org,
	Julia Lawall <julia.lawall@lip6.fr>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <dbc8c4f3-a234-9b6a-b6a4-9c7ef45d5d31@users.sourceforge.net> (sfid-20160724_221627_807874_D8019E14)
Date: Sun, 24 Jul 2016 22:15:49 +0200
MIME-Version: 1.0
In-Reply-To: <558EB32E.6090003@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>

Further update suggestions were taken into account
after a patch was applied from static source code analysis.

Markus Elfring (3):
  Delete an unnecessary check before the function call "release_firmware"
  One function call less in mac_ioctl() after error detection
  Reduce scope for a few variables in mac_ioctl()

 drivers/staging/wilc1000/linux_wlan.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

-- 
2.9.2

