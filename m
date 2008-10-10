Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35397 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752818AbYJJQ2J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 12:28:09 -0400
Message-ID: <48EF8295.1040602@hauke-m.de> (sfid-20081010_182813_198556_A622C791)
Date: Fri, 10 Oct 2008 18:28:05 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: stephen mcgregor <tech@stephen-mcgregor.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: newbie question. cant get fw-cutter to extract the firmware.
References: <loom.20081010T155930-255@post.gmane.org>
In-Reply-To: <loom.20081010T155930-255@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You must just do what is decried at
http://linuxwireless.org/en/users/Drivers/b43
Use version 4.150.10.5, version 4.150.10.5.2 is *not* supported!

export FIRMWARE_INSTALL_DIR="/lib/firmware"
wget http://mirror2.openwrt.org/sources/broadcom-wl-4.150.10.5.tar.bz2
tar xjf broadcom-wl-4.150.10.5.tar.bz2
cd broadcom-wl-4.150.10.5/driver
sudo ../../b43-fwcutter-011/b43-fwcutter -w "$FIRMWARE_INSTALL_DIR"
wl_apsta_mimo.o

--
Hauke
