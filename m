Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0IYDKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 23:10:04 -0400
Received: from wireless by sipsolutions.net with local (Exim 4.72)
	(envelope-from <wireless@sipsolutions.net>)
	id 1OzL9H-00081P-Fa
	for linux-wireless@vger.kernel.org; Sat, 25 Sep 2010 05:10:03 +0200
Date: Sat, 25 Sep 2010 05:10:03 +0200
Message-Id: <E1OzL9H-00081P-Fa@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [ANN] iw: v0.9.21
Reply-to: linux-wireless@vger.kernel.org
From: wireless@sipsolutions.net
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


A new release of iw (v0.9.21) is available at:

http://wireless.kernel.org/download/iw/iw-0.9.21.tar.bz2

SHA1 sum: 65f2537b42f23f036346631a288f6620e90c8fd8

Here is the short log of the changes included in this 
release:

Johannes Berg (16):
      update nl80211.h
      implement setting bitrate mask
      update nl80211.h
      parse supported TX/RX frame types
      make AP message more informative
      use generic length checking
      analyse HT operation IE
      make iw build on FC8
      Revert "make iw build on FC8"
      scan: don't define only an unnamed union in a struct
      phy: include string.h
      ibss: define _POSIX_SOURCE and include string.h
      define _ISOC99_SOURCE
      remove _ISOC99_SOURCE again
      use strtod() instead of strtof()
      version 0.9.21

Juuso Oikarinen (1):
      iw: Add support for setting transmit power level

