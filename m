Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:36153 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbbJZPvu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2015 11:51:50 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Zqk3j-0000vb-8b
	for linux-wireless@vger.kernel.org; Mon, 26 Oct 2015 16:51:43 +0100
Received: from 37.162.224.94 ([37.162.224.94])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 16:51:43 +0100
Received: from j.cubizolles by 37.162.224.94 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2015 16:51:43 +0100
To: linux-wireless@vger.kernel.org
From: Julien Cubizolles <j.cubizolles@free.fr>
Subject: mwifiex problem: incompatible network settings
Date: Mon, 26 Oct 2015 16:51:23 +0100
Message-ID: <87wpu9632c.fsf@free.fr> (sfid-20151026_165153_688691_CF5A4883)
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I can't connect anymore to my home wifi since upgrading my machine from
Ubuntu 15.04 to Ubuntuy 15.10. I was previously running kernel 4.3.0-rc2
from kernel.org without any problem. After the upgrade, and with the
same kernel, I couldn't connect anymore. I built 4.3.0-rc7, and the
problem remains. However, I can connect to the wifi access point from my
Android phone.

Here are the relevant lines from syslog. Let me know if you need more
information.

--8<---------------cut here---------------start------------->8---
Oct 26 16:11:38 touco wpa_supplicant[734]: wlx6045bdf646b4: Trying to associate with f4:ca:e5:ef:be:18 (SSID='southcentral' freq=2462 MHz)
Oct 26 16:11:38 touco wpa_supplicant[734]: wlx6045bdf646b4: CTRL-EVENT-ASSOC-REJECT status_code=1
Oct 26 16:11:38 touco kernel: [   66.745281] usb 1-3: info: trying to associate to 'southcentral' bssid f4:ca:e5:ef:be:18
Oct 26 16:11:38 touco kernel: [   66.745289] usb 1-3: info: mwifiex_is_network_compatible: failed: wpa_ie=0xdd wpa2_ie=0x0 WEP=d	WPA=d WPA2=d EncMode=0xfac02 privacy=0x1
Oct 26 16:11:38 touco kernel: [   66.745291] usb 1-3: Incompatible network settings
Oct 26 16:11:38 touco kernel: [   66.745294] usb 1-3: info: association to bssid f4:ca:e5:ef:be:18 failed
--8<---------------cut here---------------end--------------->8---


The machine is a Microsoft Surface Pro. I've been having a lot of
problems getting the wifi to work but never this particular one, and
they were all fixed in 4.3.0-rc2.

Julien.

