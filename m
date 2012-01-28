Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gmmr4.centrum.cz ([46.255.227.253]:48349 "EHLO gmmr4.centrum.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752424Ab2A1O4S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 09:56:18 -0500
Received: from mail1007.cent (unknown [10.32.3.101])
	by gmmr4.centrum.cz (Postfix) with ESMTP id 946BA1A001CA2
	for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2012 15:45:44 +0100 (CET)
To: <linux-wireless@vger.kernel.org>
Subject: connection interrupted for rt61pci in master mode
Date: Sat, 28 Jan 2012 15:45:44 +0100
From: <trencan@centrum.cz>
MIME-Version: 1.0
Message-Id: <20120128154544.70E060CD@centrum.cz> (sfid-20120128_155621_700454_A21897F4)
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I have RaLink RT2561/RT61 802.11g PCI wireless card and use it in master mode as AP. I have latest Mandriva 2011.0 distro with kernel 2.6.38.7-desktop-1mnb2. Driver for wifi card is rt61pci. If I connect via wifi from another PC then after some small time I get connection interrupted and I must disconnect and reconnect again. I tried latest compat-wireless-3.3-rc1-2 and also latest hostapd-0.7.3, but still same issue. In previous Mandriva version 2010.2 I had kernel 2.6.33.7-desktop-2mnb, hostapd-0.6.7 and it worked perfectly. Hostapd uses driver=nl80211, mode=g, channel=11. There are no errors in messages. I know it is not issue of the client machine, since same behavior I have if I connect to AP with HTC smartphone. Is it any known bug of rt61pci driver or hostapd?

Thanks.

Regards.
