Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:37131 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860Ab0DOTox (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 15:44:53 -0400
Received: from localhost
	([127.0.0.1] helo=purkki.valot.fi ident=kvalo)
	by purkki.valot.fi with esmtp (Exim 4.69)
	(envelope-from <kvalo@adurom.com>)
	id 1O2Uzc-0000DG-Pd
	for linux-wireless@vger.kernel.org; Thu, 15 Apr 2010 22:44:52 +0300
To: linux-wireless@vger.kernel.org
Subject: regression: soft lockup with ath9k on master-2010-04-14
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 15 Apr 2010 22:44:52 +0300
Message-ID: <87pr20mrez.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I just updated my laptop to latest wireless-testing and it everytime
soft lockups few seconds after association.

I haven't updated wireless-testing for few days, so I can't say when
this bug was introduced.

Info about my setup:

samsung x120
ubuntu 10.04 x86-64
11n ap running openwrt and ath9k, wpa2 psk

more info about chipset:

[   18.617974] ath9k 0000:02:00.0: PCI INT A -> GSI 16 (level, low) ->
IRQ 16
[   18.617989] ath9k 0000:02:00.0: setting latency timer to 64
[   18.667465] ath: EEPROM regdomain: 0x65
[   18.667468] ath: EEPROM indicates we should expect a direct regpair
map
[   18.667473] ath: Country alpha2 being used: 00
[   18.667475] ath: Regpair used: 0x65
[   18.840350] phy0: Selected rate control algorithm
'ath9k_rate_control'
[   18.841346] Registered led device: ath9k-phy0::radio
[   18.841373] Registered led device: ath9k-phy0::assoc
[   18.841400] Registered led device: ath9k-phy0::tx
[   18.841425] Registered led device: ath9k-phy0::rx
[   18.841442] phy0: Atheros AR9285 MAC/BB Rev:2 AR5133 RF Rev:e0:
mem=0xffffc90021e20000, irq=16

I will debug more tomorrow.

-- 
Kalle Valo
