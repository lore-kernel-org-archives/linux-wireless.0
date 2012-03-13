Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61350 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab2CMMkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Mar 2012 08:40:37 -0400
Received: by yhmm54 with SMTP id m54so469749yhm.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Mar 2012 05:40:36 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 13 Mar 2012 20:40:36 +0800
Message-ID: <CAG9cJmmvyG7-DJOVZoRMNaVd+_ieFyciyJcmk5ZaNoZq8EHTxA@mail.gmail.com> (sfid-20120313_134040_420764_1077736D)
Subject: compact-wireless # ./scripts/driver-select select
From: lina <lina.lastname@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Which driver I should select to install form

# ./scripts/driver-select

Supported 802.11 drivers:
	ath5k
	ath9k
	ath9k_htc
	carl9170
	ath6kl
	b43
	zd1211rw
	rt2x00
	wl1251
	wl12xx
	brcmsmac
	brcmfmac

Supported Ethernet drivers:
	atl1
	atl2
	atl1e
	atl1c

Supported group drivers:
	atheros <  ath5k ath9k carl9170 zd1211rw ath6kl >
	ath <  ath5k ath9k carl9170 ath6kl >
	brcm80211 <  brcmsmac brcmfmac >
	intel <  iwlwifi, iwlegacy >
	rtl818x <  rtl8180 rtl8187 >
	rtlwifi <  rtl8192ce >
	ti <  wl1251 wl12xx (SPI and SDIO)>

Supported group drivers: Bluetooth & Ethernet:
	atlxx <  atl1 atl2 atl1e atl1c >
	bt <  Linux bluetooth drivers >
Restoring compat-wireless:
	restore: you can use this option to restore compat-wireless to the
original state


6# lspci  | grep Net
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765
Gigabit Ethernet PCIe (rev 10)
02:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765
Memory Card Reader (rev 10)
03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n (rev 02)


Thanks for your suggestions, I wish to have a not-so-heavy installation.

Best regards,
