Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41810 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757925AbYJ3RKT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 13:10:19 -0400
Message-ID: <4909EA78.3060700@lwfinger.net> (sfid-20081030_181107_189082_5740895D)
Date: Thu, 30 Oct 2008 10:10:16 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Subject: Guidelines regarding separate directory
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am planning on adding code to control the LEDs on the RTL8187 devices based on
the latest vendor driver. From the expected size of the code, I think that
separate files will be best.

What number of files in a driver make it advisable to create a separate
directory? Between the rtl8180 and rtl8187 drivers, there are now 15 files and I
will be adding at least 2 more. Is this the time to create a rtl818x directory
under drivers/net/wireless?

Larry
