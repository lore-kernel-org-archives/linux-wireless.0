Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:42383 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbZGPMPG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 08:15:06 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1MRPrb-0005iE-Bn
	for linux-wireless@vger.kernel.org; Thu, 16 Jul 2009 12:15:03 +0000
Received: from mail.sevone.com ([mail.sevone.com])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 12:15:03 +0000
Received: from dave.mulford by mail.sevone.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 12:15:03 +0000
To: linux-wireless@vger.kernel.org
From: Dave <dave.mulford@gmail.com>
Subject: prism54 firmware cannot initialize pcmcia card
Date: Thu, 16 Jul 2009 12:09:14 +0000 (UTC)
Message-ID: <loom.20090716T120033-657@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First, some generic info about the laptop I'm using

gentoo kernel-2.6.29
prism54-firmware-2.13.2 (listed as working with in-kernel >=2.6.29 driver)
yenta_cardbus driver

Everything seems to work. The driver is loaded, the card is recognized, the
driver requests the correct firmware name, then the firmware seems to have
issues initializing the card. I have posted the relevant entries in dmesg to
http://pastebin.com/f7514c9c0

Any help is appreciated. Thanks!

Regards,
Dave

