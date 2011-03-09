Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35452 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab1CIK7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2011 05:59:09 -0500
Received: by qyk7 with SMTP id 7so3681580qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 02:59:08 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 9 Mar 2011 11:59:08 +0100
Message-ID: <AANLkTim9hhX1VV93X7-+61hNsxit=AJiHgrt9ByWg9+V@mail.gmail.com>
Subject: Problem with BCM943224
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've 14e4:4353 labeled as BCM943224HMS / DW1520

[  199.009268] brcm80211: module is from the staging directory, the
quality is unknown, you have been warned.
[  199.022493] brcm80211 0000:03:00.0: enabling device (0000 -> 0002)
[  199.022529] brcm80211 0000:03:00.0: PCI INT A -> GSI 28 (level,
low) -> IRQ 28
[  199.022543] brcm80211 0000:03:00.0: setting latency timer to 64
[  199.050090] cfg80211: World regulatory domain updated:
[  199.050096] cfg80211:     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  199.050101] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  199.050105] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  199.050109] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  199.050113] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  199.050117] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  199.297803] Found chip of unknown type (0xffffffff)
[  199.297808] wl0: wlc_bmac_attach: si_attach failed
[  199.297813] wl0: wlc_bmac_attach: failed with err 11
[  199.297818] wl0: wlc_attach: failed with err 11
[  199.297856] brcm80211: wlc_attach() failed with code 11
[  199.297882] brcm80211: wl_pci_probe: wl_attach failed!

[  343.223842] wl: module license 'unspecified' taints kernel.
[  343.223849] Disabling lock debugging due to kernel taint
[  343.256069] wl 0000:03:00.0: setting latency timer to 64
[  343.258760] eth%d: 5.100.82.38 driver failed with code 11

It seems all reads are 1 (0xffffffff). Can this be some bug in driver?
Can this be because I use adapter mini PCIe to PCIe x1? I remember
such a situation when I connected adapter to PCIe x16 and used N-PHY
card SSB based.

-- 
Rafał
