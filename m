Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49111 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbYLILvP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 06:51:15 -0500
Subject: wireless drivers sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Dan Williams <dcbw@redhat.com>, simon@thekelleys.org.uk,
	Bob Copeland <me@bobcopeland.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Pavel Roskin <proski@gnu.org>, David Gibson <dwg@au1.ibm.com>,
	Daniel Drake <dsd@gentoo.org>
Content-Type: text/plain
Date: Tue, 09 Dec 2008 12:50:35 +0100
Message-Id: <1228823435.22164.216.camel@johannes.berg> (sfid-20081209_125136_394228_BC992C34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[minus uninteresting ones like "should be static"]

drivers/net/wireless/airo.c:3804:8: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3715:6: originally declared here
drivers/net/wireless/airo.c:3811:8: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3715:6: originally declared here
drivers/net/wireless/airo.c:3825:7: warning: symbol 'i' shadows an earlier one
drivers/net/wireless/airo.c:3715:6: originally declared here
drivers/net/wireless/airo.c:2041:10: warning: incorrect type in assignment (different base types)
drivers/net/wireless/airo.c:2041:10:    expected restricted __le16 [usertype] status
drivers/net/wireless/airo.c:2041:10:    got unsigned short [unsigned] [usertype] status
drivers/net/wireless/airo.c:2093:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2093:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2093:14:    got int *<noident>
drivers/net/wireless/airo.c:2117:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2117:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2117:14:    got int *<noident>
drivers/net/wireless/airo.c:2158:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2158:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2158:14:    got int *<noident>
drivers/net/wireless/airo.c:2182:14: warning: incorrect type in initializer (different signedness)
drivers/net/wireless/airo.c:2182:14:    expected unsigned int [usertype] *fids
drivers/net/wireless/airo.c:2182:14:    got int *<noident>

drivers/net/wireless/atmel.c:3639:23: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3640:24: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3641:23: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3642:25: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3643:23: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3644:24: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3645:23: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3646:25: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3647:25: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3648:23: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3649:25: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3650:25: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3651:21: warning: cast to restricted __le16
drivers/net/wireless/atmel.c:3652:22: warning: cast to restricted __le16

drivers/net/wireless/ath5k/pcu.c:1102:21: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath5k/pcu.c:1102:13: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath5k/pcu.c:1102:13:    expected restricted __le32 <noident>
drivers/net/wireless/ath5k/pcu.c:1102:13:    got unsigned int
drivers/net/wireless/ath5k/pcu.c:1104:20: warning: restricted __le32 degrades to integer
drivers/net/wireless/ath5k/pcu.c:1104:13: warning: incorrect type in assignment (different base types)
drivers/net/wireless/ath5k/pcu.c:1104:13:    expected restricted __le32 <noident>
drivers/net/wireless/ath5k/pcu.c:1104:13:    got unsigned int

drivers/net/wireless/ath9k/hw.c:1922:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:1785:6: originally declared here
drivers/net/wireless/ath9k/hw.c:2123:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:2033:6: originally declared here
drivers/net/wireless/ath9k/main.c:2657:28: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath9k/main.c:2657:28:    expected restricted pci_power_t [usertype] state
drivers/net/wireless/ath9k/main.c:2657:28:    got int

drivers/net/wireless/orinoco/airport.c:282:2: warning: returning void-valued expression

drivers/net/wireless/zd1211rw/zd_usb.c:361:17: warning: implicit cast from nocast type


