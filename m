Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41700 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3CPSTa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:30 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: [PATCH 0/25] rt2800: add experimental support for 5592 chip
Date: Sat, 16 Mar 2013 19:19:28 +0100
Message-Id: <1363457993-15541-1-git-send-email-stf_xl@wp.pl> (sfid-20130316_191934_726920_C0E51D36)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch set add support for 5592 a new Ralink wlan chip. Register
programming code is all is based on Ralink linux driver available at
(despite the url it linux driver download web page ):

http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501

Currently only support for USB devices is added, PCIe is on the way
together with some other changes that will clean BBP/RF rt2800
programming code, which is now quite Lionel (messy :-).

 Kconfig     |    7 
 rt2800.h    |  103 ++++++-
 rt2800lib.c |  857 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++----
 rt2800pci.c |    5 
 rt2800usb.c |   63 ++++
 rt2x00.h    |   10 
 6 files changed, 989 insertions(+), 56 deletions(-)

