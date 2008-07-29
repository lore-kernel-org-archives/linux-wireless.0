Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.189]:60166 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660AbYG2CVI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 22:21:08 -0400
Received: by ti-out-0910.google.com with SMTP id b6so2452446tic.23
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2008 19:21:06 -0700 (PDT)
Reply-To: <cs010101@gmail.com>
From: =?ks_c_5601-1987?B?sei/tciv?= <cs010101@gmail.com>
To: <linux-wireless@vger.kernel.org>,
	<madwifi-users@lists.sourceforge.net>
Cc: <hostap@lists.shmoo.com>
Subject: Q) AP mode disconnected in MadWiFi
Date: Tue, 29 Jul 2008 11:21:00 +0900
Message-ID: <003a01c8f121$c0641b60$3b0aa8c0@39fb6b6b6f434b3> (sfid-20080729_042117_169456_9420D4CF)
MIME-Version: 1.0
Content-Type: text/plain; charset=ks_c_5601-1987
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I did AP mode in MadWiFi because compat-driver does not support AP mode=
=2E

Configuration :

wlanconfig wlan0 create wlandev wifi0 wlanmode ap
iwconfig wlan0 essid "MadWiFi" channel 161
brctl addbr br0
brctl addif br0 eth2(active ethernet)
brctl addif br0 wlan0 // actually, I did "brctl addif br0" according to
MadWiFi user-manual, it didn'y work.
brctl serfd br0 1
ifconfig wlan0 up
ifconfig eth2 up
ifconfig br0 [ip address] up

then I did connect my laptop to AP(mad-wifi). it was good operation!!
BUT the connection was failed in just a moment.
so, I saw net-dev status using "ifconfig".=20

by the way, wlan0 and wifi0-00 disappeared. -.-;; why?


thanks.


--
--
Have a Wonderful Day~~!!
M.Sc =B1=E8=BF=B5=C8=AF (James-Youngwhan Kim)
yhkim@corebell.co.kr
cs010101@gmail.com
+82-42-863-0340 (222)
+82-10-6753-0987
HTVC 3106 KAIST, 373-1 Guseong-dong, Yuseong-gu,
Daejon,  Republic of Korea
305-701

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
