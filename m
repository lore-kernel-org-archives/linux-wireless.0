Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:40570 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaHBXfG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2014 19:35:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1XDipL-00070O-Kv
	for linux-wireless@vger.kernel.org; Sun, 03 Aug 2014 01:35:03 +0200
Received: from p54946fa4.dip0.t-ipconnect.de ([84.148.111.164])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 01:35:03 +0200
Received: from Manuel.Spam by p54946fa4.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2014 01:35:03 +0200
To: linux-wireless@vger.kernel.org
From: Manuel Reimer <Manuel.Spam@nurfuerspam.de>
Subject: Problems with rtl8192cu driver (disassociated from ... (Reason: 2))
Date: Sun, 03 Aug 2014 01:29:49 +0200
Message-ID: <lrjs9d$s51$1@ger.gmane.org> (sfid-20140803_013520_316353_6CD43BA0)
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm trying to get access to a WLAN access point using the following adapter:

<http://www.edimax.com/edimax/merchandise/merchandise_detail/data/edimax/global/wireless_adapters_n150/ew-7811un>

I've used "NetworkManager" to connect to the access point and everything 
seemed to work well at first.

But after a few minutes the connection is lost with the following 
message in dmesg:

wlan0: disassociated from XX:XX:XX:XX:XX:XX (Reason: 2)

If I restart NetworkManager, then the connection works again, but only 
for a few minutes before I get another disconnect.

I even tried to do a permanent ping to a server on the Internet (to have 
permanent traffic) but this doesn't change anything. I still get 
disconnected with "Reason 2".

Are there known problems with the rtl8192cu driver?

Can someone here recommend a small USB WLAN adapter which is known to 
work without problems?

Thank you very much in advance.

Greetings

Manuel

