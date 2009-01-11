Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:45311 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325AbZAKAKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Jan 2009 19:10:16 -0500
From: Christian Lamparter <chunkeey@web.de>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 0/4] p54: p54spi driver
Date: Sun, 11 Jan 2009 01:10:12 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200901110110.12634.chunkeey@web.de> (sfid-20090111_011021_706328_4819DCD7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series introduce a driver for stlc4550/stlc4560 chips.

So far no one complained about the patches.
=> therefore it must be 100% working!

[Please mind the logic gap ;-) , But I hope someone will respond
when the whole driver can be built with compat-wireless.]

Changes:
	v1 -> v2 =>
		- no more sparse warnings! ( hopefully :-p )
		- put the eeprom parser changes into a separated patch
		- removed some duplicated/unused #define and code
		- updated p54spi's kconfig entry
		- added Johannes (C) to p54spi.c
		- (the patches should be applied on top of "[PATCH 3/3] p54: fix oops caused by bad eeproms")

Regards,
        Chr
