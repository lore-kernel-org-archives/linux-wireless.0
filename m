Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28302.mail.ukl.yahoo.com ([87.248.110.121]:41246 "HELO
	web28302.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754150AbZIGSxW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Sep 2009 14:53:22 -0400
Message-ID: <56766.82568.qm@web28302.mail.ukl.yahoo.com>
Date: Mon, 7 Sep 2009 18:46:43 +0000 (GMT)
From: Albert Herranz <albert_herranz@yahoo.es>
Subject: [PATCH RFC 0/3] summary: ssb: add support for ssb over sdio
To: bcm43xx-dev@lists.berlios.de
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following patchset against wireless-testing enable support for the Sonics Silicon Backplane over Secure Digital IO as found in the SDIO-based b43 wireless network card present in the Nintendo Wii video game console. (This same infrastructure _may_ be used for other SDIO-based b43 cards aswell).

[PATCH RFC 1/3] sdio: recognize io card without powercycle
[PATCH RFC 2/3] sdio: pass unknown cis tuples to sdio drivers
[PATCH RFC 3/3] ssb: add support for ssb over sdio

Cheers,
Albert



      
