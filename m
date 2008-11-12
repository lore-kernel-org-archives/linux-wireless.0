Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.freemail.gr ([81.171.104.132]:47393 "EHLO smtp.freemail.gr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYKLXcL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 18:32:11 -0500
Received: from [192.168.1.2] (adsl36-212.lsf.forthnet.gr [79.103.163.212])
	by smtp.freemail.gr (Postfix) with ESMTP id AC5A53380F1
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2008 01:20:53 +0200 (EET)
From: Karakontakis Apostolos <akarako@freemail.gr>
To: linux-wireless@vger.kernel.org
Subject: zd1211rw problem
Date: Thu, 13 Nov 2008 01:20:48 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200811130120.48659.akarako@freemail.gr> (sfid-20081113_003214_098900_07B3B635)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have recenetly bought a usb wireless stick that requires zd1211rw driver 
(ZyDAS ZD1211B chipset).With kernel 2.6.24 it works ok but with kernel 
2.6.27.2 it dos not.

1. I have the latest firmware in /lib/firmware/zd1211
2. i have CONFIG_MAC80211 and CONFIG_FW_LOADER = y
3. i have CONFIG_ZD1211RW=m

when i insert the module i get the following errors

Nov 13 01:02:20 hakarako kernel: mac80211: Unknown parameter 
`ieee80211_regdom'
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_free_hw
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_alloc_hw
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
ieee80211_register_hw
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
ieee80211_tx_status_irqsafe
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
ieee80211_wake_queues
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
ieee80211_stop_queues
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol 
ieee80211_unregister_hw
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_beacon_get
Nov 13 01:02:20 hakarako kernel: zd1211rw: Unknown symbol ieee80211_rx_irqsafe
