Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tdb.com ([216.99.214.4]:35030 "HELO mail.tdb.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755475Ab1EATqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 15:46:09 -0400
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: kernel panic on MIPS + ath5k + Wistron CM9 radio
From: Russell Senior <seniorr@aracnet.com>
Date: Sun, 01 May 2011 12:39:16 -0700
Message-ID: <861v0igqhn.fsf@coulee.tdb.com> (sfid-20110501_214613_950427_D5B467EF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Recently trying to abandon madwifi for good on some embedded devices
with OpenWrt, encountered kernel panics.  Same radio on an x86
platform (Soekris net4826), no kernel panic.  Different atheros radio,
no kernel panic.  Tried two different MIPS boards (Netgear WGT634U and
Ubiquiti RouterStation), both panic'd.

Netgear WGT634U:  http://pastebin.ca/2051127
Ubiquiti RouterStation: http://pastebin.ca/2052610

Both cases were firmwares built from r26771 of OpenWrt, and both seem
to have panic'd from hostapd.  While researching this, I encountered a
similar report from last June:

  http://www.mail-archive.com/openwrt-users@lists.openwrt.org/msg01001.html
  http://www.spinics.net/lists/linux-wireless/msg52502.html

Another person reported some issues with the CM9 earlier this year in
client mode:

  http://permalink.gmane.org/gmane.linux.drivers.ath5k.devel/4722

I am happy to do some leg work on getting this fixed, if someone can
provide some guidance.  Thanks!


-- 
Russell Senior         ``I have nine fingers; you have ten.''
seniorr@aracnet.com
