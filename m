Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:63988 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZDVUU6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 16:20:58 -0400
Received: by bwz7 with SMTP id 7so178002bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 13:20:56 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Cc: luciano.coelho@nokia.com, Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
Subject: wl12xx: second submission
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 23:20:53 +0300
Message-ID: <87hc0gcue2.fsf@litku.valot.fi> (sfid-20090422_222101_942112_9138A98A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

here is the second submission of wl12xx, a driver for TI wl1251 chipset:

http://www.valot.fi/kalle/tmp/wl12xx/20090422/

Changes since last submission from February 10:

o update to 2.6.29 (bob)
o sysfs interface removed (bob)
o netlink interface removed 
o lots of bug fixes
o platform data for proper board file support

Please consider for including the driver to wireless-testing. Bob is
planning to add SDIO support to the driver and it's easier for us to
have the driver in wireless-testing. And if all goes well, it would be
nice to get the driver into 2.6.31. But that's up to you, of course.

-- 
Kalle Valo
