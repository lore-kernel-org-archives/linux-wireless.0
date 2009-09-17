Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx30.mail.ru ([94.100.176.44]:49430 "EHLO mx30.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755067AbZIQMPn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 08:15:43 -0400
Received: from [94.242.37.174] (port=43577 helo=zhubr.mshome.net)
	by mx30.mail.ru with asmtp
	id 1MoFtp-0004su-00
	for linux-wireless@vger.kernel.org; Thu, 17 Sep 2009 16:15:45 +0400
Date: Thu, 17 Sep 2009 16:22:42 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <1214494232.20090917162242@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: 2.6.25 kernel & compat-wireless-2009-09-14
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello people,

So finally I got it mostly working and usable as AP:

Hardware:
* ASUS WL-500gP (mips) with stock wireless card removed (broadcom).
* New shining Ralink RT2600 Mini-PCI card
Software:
* kernel 2.6.25.20 (openwrt 8.09.1)
* compat-wireless-2009-09-14 (without rfkill_backport and with ugly bus_id fix)
libnl-1.1
hostapd 0.6.9

The led is now even blinking nicely.
Strange though that selecting static IP in the client didn't work,
but using DHCP works fine (it's ok for me now).

 Nikolai


