Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbbCFWPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 17:15:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: Larry.Finger@lwfinger.net, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 0/1] New driver: rtl8723au (mac80211)
Date: Fri,  6 Mar 2015 17:15:25 -0500
Message-Id: <1425680126-25928-1-git-send-email-Jes.Sorensen@redhat.com> (sfid-20150306_231533_220363_71D79D23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is a new driver for the rtl8723au which was written from scratch,
to utilize the Linux mac80211 stack.

This has been a pet project for me for some time I finally feel it
is stable enough to submit. I have used it for a while without any
serious issues.

I started working on cleaning up the vendor provided driver in
staging/rtl8723au over a year ago. After spending 6 months on it, it
became obvious to me that it was a rather hopeless task, and I started
writing this driver from scratch. I do not have any specs for the
chip, so everything is based on knowledge I obtained from dissecting
the vendor driver.

Special thanks to Larry Finger for help with the original rtl8723au
driver, and Johannes Berg for answering all my silly questions about
802.11 innards and the mac80211 stack. Had I known then what I know
today about 802.11, I probably would never have so mad as to start
this project in the first place!

Cheers,
Jes


Jes Sorensen (1):
  New driver: rtl8723au (mac80211)

 MAINTAINERS                          |    9 +
 drivers/net/wireless/Kconfig         |   19 +
 drivers/net/wireless/Makefile        |    2 +
 drivers/net/wireless/rtl8xxxu.c      | 4465 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/rtl8xxxu.h      |  497 ++++
 drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++
 6 files changed, 5933 insertions(+)
 create mode 100644 drivers/net/wireless/rtl8xxxu.c
 create mode 100644 drivers/net/wireless/rtl8xxxu.h
 create mode 100644 drivers/net/wireless/rtl8xxxu_regs.h

-- 
2.1.0

