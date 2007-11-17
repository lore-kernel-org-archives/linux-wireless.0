Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.176]:41492 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762990AbXKQAtJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Nov 2007 19:49:09 -0500
Received: by py-out-1112.google.com with SMTP id u77so4525974pyb
        for <linux-wireless@vger.kernel.org>; Fri, 16 Nov 2007 16:49:08 -0800 (PST)
Message-ID: <43e72e890711161649w6f9f5368h4234126bf8350077@mail.gmail.com> (sfid-20071117_004915_489346_1FFB1047)
Date: Fri, 16 Nov 2007 19:49:08 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: wireless <linux-wireless@vger.kernel.org>
Subject: Linux wireless compatibility package updated - v2.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've updated the compatibility package with all the new drivers we
have on wireless-2.6.git#everything. Here's the complete list:

adm8211
ath5k
b43
b43legacy
iwl3945
iwl4965
libertas_cs (Libertas)
ub8xxx      (Libertas)
p54pci
p54usb
rt2400pci (rt2x00)
rt2500pci (rt2x00)
rt2500usb (rt2x00)
rt61pci   (rt2x00)
rt73usb   (rt2x00)
rtl8180 (Realtek)
rtl8187 (Realtek)
zd1211rw-mac80211

The ones I've tested so far and on 2.6.22:

ath5k
b43
iwl3945
p54pci (on FullMAC card)
rt2500pci
rtl8180
zd1211rw-mac80211

I'd appreciate it if people with other hardware let me know how it
goes for them. For further information please refer to our wiki:

http://linuxwireless.org/en/users/Download

  Luis
