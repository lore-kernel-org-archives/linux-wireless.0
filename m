Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35927 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbbAaGTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2015 01:19:17 -0500
Received: by mail-wi0-f172.google.com with SMTP id h11so7156050wiw.5
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 22:19:16 -0800 (PST)
Received: from localhost (iskon3992.duo.carnet.hr. [31.147.111.152])
        by mx.google.com with ESMTPSA id a20sm9882887wic.16.2015.01.30.22.19.14
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Jan 2015 22:19:15 -0800 (PST)
Message-ID: <54CC73E2.3040208@gmail.com> (sfid-20150131_072335_263556_E02D34A9)
Date: Sat, 31 Jan 2015 07:19:14 +0100
From: poma <pomidorabelisima@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Realtek RTL8812AE 802.11ac
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Salutem


Is the combination with Bluetooth only essential difference between RTL8821AE and RTL8812AE?

*If* the undermentioned two devices are based on RTL8812AE chipset,
whether they supported via 'rtl8821ae.ko' & 'rtl8821aefw.bin'?

PCIe RTL8812AE 802.11abgn+ac 2x2:2


Amped Wireless PCI20E (FCC ID: ZTT-PCI20E) 
  https://wikidevi.com/wiki/Amped_Wireless_PCI20E

- High Power AC1200 Wi-Fi PCI-E Adapter 
  PCI20E
  http://www.ampedwireless.com/products/pci20e.html

- http://www.amazon.com/Amped-Wireless-AC1200-Adapter-PCI20E/dp/B00I9AS1JA


D-Link DWA-582 rev A1 (FCC ID: KA2WA582A1) 
  https://wikidevi.com/wiki/D-Link_DWA-582_rev_A1

- Wireless AC1200 Dual Band PCIe Desktop Adapter
  DWA-582
  http://www.dlink.com.au/home-solutions/wireless-ac1200-dual-band-pcie-desktop-adapter

- http://www.amazon.com/WIRELESS-AC1200-EXPRESS-ADAPTER-DUAL/dp/B00PHVQV14


/usr/src/kernels/3.18.3-201.fc21.x86_64/drivers/net/wireless/rtlwifi/Kconfig
...
config RTL8821AE
        tristate "Realtek RTL8821AE/RTL8812AE Wireless Network Adapter"
        depends on PCI
        select RTLWIFI
        select RTLWIFI_PCI
        select RTLBTCOEXIST
        ---help---
        This is the driver for Realtek RTL8i821AE/RTL8812AE 802.11av PCIe
        wireless network adapters.

        If you choose to build it as a module, it will be called rtl8821ae
...


$ modinfo rtl8821ae
filename:       /lib/modules/3.18.3-201.fc21.x86_64/kernel/drivers/net/wireless/rtlwifi/rtl8821ae/rtl8821ae.ko.xz
firmware:       rtlwifi/rtl8821aefw.bin
description:    Realtek 8821ae 802.11ac PCI wireless
license:        GPL
author:         Realtek WlanFAE	<wlanfae@realtek.com>
alias:          pci:v000010ECd00008821sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008812sv*sd*bc*sc*i*
depends:        rtlwifi,rtl_pci,btcoexist,mac80211
...


poma

