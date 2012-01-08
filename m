Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2AHLxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 06:53:04 -0500
Received: by iaeh11 with SMTP id h11so5243672iae.19
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jan 2012 03:53:04 -0800 (PST)
Message-ID: <4F098398.8090004@gmail.com> (sfid-20120108_125310_309550_DA1DB462)
Date: Sun, 08 Jan 2012 19:52:56 +0800
From: lina <lina.lastname@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: which one I can safely removed to lose some weight?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

after install the b43 related packages, my / become so heavy suddenly, 
reached 84%.

now

:/lib/modules/3.2.0-1-lina/updates/drivers/net/wireless# ls
adm8211.ko       brcm80211     libertas           orinoco        rtlwifi
at76c50x-usb.ko  ipw2x00       libertas_tf        p54            wl1251
ath              iwlegacy      mac80211_hwsim.ko  rndis_wlan.ko  wl12xx
b43              iwlwifi       mwifiex            rt2x00         zd1211rw
b43legacy        iwmc3200wifi  mwl8k.ko           rtl818x

root@dove:/lib/modules/3.2.0-1-lina/updates/drivers/net/wireless# du -sh
141M    .

I wonder above director, which one I can safely remove:

# lspci | grep Broad
02:00.0 Ethernet controller: Broadcom Corporation NetXtreme BCM57765 
Gigabit Ethernet PCIe (rev 10)
02:00.1 SD Host controller: Broadcom Corporation NetXtreme BCM57765 
Memory Card Reader (rev 10)
03:00.0 Network controller: Broadcom Corporation BCM4331 802.11a/b/g/n 
(rev 02)


I can keep it, just in case there are some redundant packages to take 
the place,

Thanks for any advice,

