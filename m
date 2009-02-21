Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:36930 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183AbZBUPJY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 10:09:24 -0500
Message-ID: <49A01922.1090106@lwfinger.net> (sfid-20090221_160928_943263_A64D4D4A)
Date: Sat, 21 Feb 2009 09:09:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Signal quality strange since commit 708c57cf1709fb95
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I admit that I didn't follow the discussion of reporting signal quality very
closely; however since commit 708c57cf1709fb95, all of my wireless devices (b43,
p54usb, rtl8187) are reporting link quality as XX/70 rather than XX/100. I doubt
that this was an intended consequence of that patch. If the SIOCGIWRANGE ioctl
is now more correct, what changes are needed in the drivers to restore the old
behavior? Having written the qual calculation for 2 drivers, I understand the
uselessness of this number, but I also know the uproar such a change will cause
in the user community.

Larry
