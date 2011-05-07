Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hqemgate03.nvidia.com ([216.228.121.140]:16894 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735Ab1EGAk1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 20:40:27 -0400
From: Rhyland Klein <rklein@nvidia.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: olof@lixom.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH] add support for rfkill gpio devices
Date: Fri,  6 May 2011 17:40:00 -0700
Message-Id: <1304728801-21331-1-git-send-email-rklein@nvidia.com> (sfid-20110507_024041_577060_F12875B3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a rewrite of the bt_rfkill driver that Anantha first sent out
in mid April. I tried to take into account all comments, and ended up with
what I hope to be a simple yet useful base generic gpio rfkill driver.

Please feel free to point out areas that could use changes as I am new to
the rfkill subsystem and rfkill devices in general.

Rhyland Klein (1):
  net: rfkill: add generic gpio rfkill driver

 include/linux/rfkill-gpio.h |   45 ++++++++++
 net/rfkill/Kconfig          |    7 ++
 net/rfkill/Makefile         |    1 +
 net/rfkill/rfkill-gpio.c    |  199 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 252 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/rfkill-gpio.h
 create mode 100644 net/rfkill/rfkill-gpio.c

-- 
1.7.5

