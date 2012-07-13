Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:45200 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933498Ab2GMSwf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 14:52:35 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org, ilw@linux.intel.com,
	users@rt2x00.serialmonkey.com, b43-dev@lists.infradead.org,
	brcm80211-dev-list@broadcom.com, chunkeey@googlemail.com,
	buytenh@wantstofly.org, dsd@gentoo.org, coelho@ti.com,
	johannes.berg@intel.com
Subject: mac80211: Restructure ieee80211_tx_info->control to gain free space along tx-path 
Date: Fri, 13 Jul 2012 20:52:23 +0200
Message-Id: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120713_205241_278429_6F695FF2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to enable new annotations per data packet along the max80211 tx-path,
(e.g. upcoming Transmit Power Control (TPC) per packet) this patch-serie does:

- fix the ieee80211_tx_info->control usage in driver mac80211_hwsim
- remove control.sta from ieee80211_tx_info and adapt all affected drivers


Greetings Thomas                                                                                                                                                                                                                        

---
CC list is a reduced "get_maintainer.pl", focuses on mailing lists - suggested
by J. Berg

