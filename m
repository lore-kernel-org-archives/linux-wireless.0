Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f192.google.com ([209.85.222.192]:52807 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZH0A1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 20:27:35 -0400
Received: by pzk30 with SMTP id 30so693575pzk.4
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 17:27:37 -0700 (PDT)
Message-ID: <4A95D2A8.9090208@lwfinger.net>
Date: Wed, 26 Aug 2009 19:26:16 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>, Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Congratulations
References: <1251323178-7173-1-git-send-email-netrolller.3d@gmail.com>
In-Reply-To: <1251323178-7173-1-git-send-email-netrolller.3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gábor,

Congratulations on your progress. With today's patches my BCM4312
802.11b/g card with PCI ID 14e4:4315 works - I'm using it at the
moment. I'm using WPA2 encryption and have connected to APs on
channels 1 and 11. My logs are clean.

As you noted, performance is a little weak, but I get transmits of
9-11 Mb/s and receive rates up to 18 Mb/s - eminently usable.

I certainly hope that you get the patches approved so that these
changes will be in the 2.6.32 kernel.

Once again, congratulations to you, Michael, and the others members of
the reverse engineering team. Seeing the device comes to life makes
all those hours of staring at MIPS binary code seem very worthwhile.

For those of you with N PHYs, the RE of those devices will be my next
step.

Larry
