Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38371 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYIKKqx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 06:46:53 -0400
Subject: sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Buesch <mb@bu3sch.de>, Chr <chunkeey@web.de>,
	Daniel Drake <dsd@gentoo.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 12:46:14 +0200
Message-Id: <1221129974.6986.8.camel@johannes.berg> (sfid-20080911_124656_975268_BEAFFBED)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Please fix at your leisure:

drivers/net/wireless/ath9k/hw.c:4773:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:4636:6: originally declared here
drivers/net/wireless/ath9k/hw.c:4975:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:4885:6: originally declared here
drivers/net/wireless/ath9k/main.c:1557:28: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/ath9k/main.c:1557:28:    expected restricted pci_power_t [usertype] state
drivers/net/wireless/ath9k/main.c:1557:28:    got int

drivers/net/wireless/iwlwifi/iwl3945-base.c:4886:18: warning: invalid assignment: |=
drivers/net/wireless/iwlwifi/iwl3945-base.c:4886:18:    left side has type unsigned char
drivers/net/wireless/iwlwifi/iwl3945-base.c:4886:18:    right side has type restricted __le32
[and some more I have ignored because they seem to be bogus]

drivers/net/wireless/b43/phy_g.c:57:10: warning: symbol 'b43_radio_channel_codes_bg' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:218:6: warning: symbol 'b43_set_txpower_g' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:386:6: warning: symbol 'b43_nrssi_hw_write' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:393:5: warning: symbol 'b43_nrssi_hw_read' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:404:6: warning: symbol 'b43_nrssi_hw_update' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:418:6: warning: symbol 'b43_nrssi_mem_update' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:592:6: warning: symbol 'b43_calc_nrssi_slope' was not declared. Should it be static?
drivers/net/wireless/b43/phy_g.c:1357:5: warning: symbol 'b43_radio_init2050' was not declared. Should it be static?
drivers/net/wireless/b43/phy_a.c:80:6: warning: symbol 'b43_radio_set_tx_iq' was not declared. Should it be static?
drivers/net/wireless/b43/phy_a.c:150:6: warning: symbol 'b43_radio_init2060' was not declared. Should it be static?
drivers/net/wireless/b43/phy_n.c:33:6: warning: symbol 'b43_nphy_set_rxantenna' was not declared. Should it be static?
drivers/net/wireless/b43/phy_n.c:188:6: warning: symbol 'b43_nphy_radio_turn_on' was not declared. Should it be static?
drivers/net/wireless/b43/phy_n.c:193:6: warning: symbol 'b43_nphy_radio_turn_off' was not declared. Should it be static?
drivers/net/wireless/b43/phy_n.c:419:5: warning: symbol 'b43_phy_initn' was not declared. Should it be static?

drivers/net/wireless/p54/p54common.c:152:38: warning: incorrect type in argument 1 (different base types)
drivers/net/wireless/p54/p54common.c:152:38:    expected restricted __be32 const [usertype] *p
drivers/net/wireless/p54/p54common.c:152:38:    got unsigned int *<noident>
drivers/net/wireless/p54/p54common.c:184:15: warning: restricted __le32 degrades to integer
drivers/net/wireless/p54/p54common.c:185:29: warning: cast to restricted __le16
drivers/net/wireless/p54/p54common.c:185:29: warning: cast to restricted __le16
drivers/net/wireless/p54/p54common.c:185:29: warning: cast to restricted __le16
drivers/net/wireless/p54/p54common.c:185:29: warning: cast to restricted __le16
drivers/net/wireless/p54/p54common.c:309:11: warning: symbol 'p54_rf_chips' was not declared. Should it be static?
drivers/net/wireless/p54/p54common.c:313:5: warning: symbol 'p54_parse_eeprom' was not declared. Should it be static?
drivers/net/wireless/p54/p54common.c:620:43: warning: incorrect type in argument 3 (different base types)
drivers/net/wireless/p54/p54common.c:620:43:    expected unsigned int [unsigned] [usertype] <noident>
drivers/net/wireless/p54/p54common.c:620:43:    got restricted __le16 [usertype] len
drivers/net/wireless/p54/p54common.c:780:41: warning: restricted __le16 degrades to integer
drivers/net/wireless/p54/p54common.c:781:32: warning: restricted __le16 degrades to integer
drivers/net/wireless/p54/p54common.c:1250:28: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/p54/p54common.c:1250:28:    expected unsigned short [unsigned] [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1250:28:    got restricted __le16 [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1252:28: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/p54/p54common.c:1252:28:    expected unsigned short [unsigned] [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1252:28:    got restricted __le16 [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1257:42: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/p54/p54common.c:1257:42:    expected unsigned short [unsigned] [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1257:42:    got restricted __le16
drivers/net/wireless/p54/p54common.c:1260:42: warning: incorrect type in argument 2 (different base types)
drivers/net/wireless/p54/p54common.c:1260:42:    expected unsigned short [unsigned] [usertype] filter_type
drivers/net/wireless/p54/p54common.c:1260:42:    got restricted __le16
drivers/net/wireless/p54/p54usb.c:228:10: warning: restricted __le32 degrades to integer
drivers/net/wireless/p54/p54usb.c:228:23: warning: restricted __le32 degrades to integer
drivers/net/wireless/p54/p54usb.c:228:7: warning: incorrect type in assignment (different base types)
drivers/net/wireless/p54/p54usb.c:228:7:    expected restricted __le32 [assigned] [usertype] chk
drivers/net/wireless/p54/p54usb.c:228:7:    got unsigned int
drivers/net/wireless/p54/p54usb.c:221:8: warning: symbol 'p54u_lm87_chksum' was not declared. Should it be static?

drivers/net/wireless/zd1211rw/zd_mac.c:756:6: warning: symbol 'zd_process_intr' was not declared. Should it be static?
drivers/net/wireless/zd1211rw/zd_usb.c:358:17: warning: implicit cast from nocast type
drivers/net/wireless/zd1211rw/zd_usb.c:358:17: warning: implicit cast from nocast type

johannes

