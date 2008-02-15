Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:14860 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856AbYBORoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2008 12:44:24 -0500
Received: by wf-out-1314.google.com with SMTP id 28so109366wff.4
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2008 09:44:23 -0800 (PST)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: how do I fix for 802.11a in zd1211rw? and please recommand products for 802.11a
Date: Sat, 16 Feb 2008 02:44:24 +0900
Message-ID: <002001c86ffa$6921f780$020aa8c0@39fb6b6b6f434b3> (sfid-20080215_174427_003245_E61EDD53)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

^^ hello everyone.

last time, I tested 3com pci card (atheros) and now testing zd1211b.
the general product name is AG-760A.(usb dongle)
(only for using 802.11a ad-hoc)

I took a look at the source : zd_mac.c , zd_usb.c, etc...
In these files, I could see the "/* FIXME for 802.11a*/ comment block. so,
I changed 2GHZ to 5GHZ and 24GHZ to 52GHZ etc..(also with productid)

the device was registered and zd1211rw_mac80211 drivers were loaded.
but when doing iwlist [device] channel, I can only show me 2Ghz channels...

how do I fix for 802.11a?


thanks.


 
P.S if you've guarantee stable operation for 802.11a(with ad-hoc),  plz
give me the product name
( i want to know the product models using 802.11a and being supported in
current certified linux kernel driver)

