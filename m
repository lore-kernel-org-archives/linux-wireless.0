Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ro.mikronika.com.pl ([213.17.224.85]:22076 "EHLO
	cluster1.mikronika.com.pl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751672AbYIZN2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 09:28:42 -0400
Received: from [192.168.3.203] (szkudlarekk-lap.mikronika.com.pl [192.168.3.203])
	(authenticated bits=0)
	by cluster1.mikronika.com.pl (8.13.4/8.13.4) with ESMTP id m8QDSe7a024761
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 15:28:41 +0200
Message-ID: <48DCE386.1050800@mikronika.com.pl> (sfid-20080926_152846_108856_F6BF3ABF)
Date: Fri, 26 Sep 2008 15:28:38 +0200
From: Karol Szkudlarek <karol@mikronika.com.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: compilation error of compat-wireless-2008-09-26 with ETH_P_PAE
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!
I have the following compilation error of the latest compat-wireless=20
drivers.
I am using Ubuntu Hardy Heron with 2.6.27-4 linux kernel.

karol@szkudlarekk-lap:~/tmp/downloads/compat-wireless-2008-09-26$ make
make -C /lib/modules/2.6.27-4-generic/build=20
M=3D/home/karol/tmp/downloads/compat-wireless-2008-09-26 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.27-4-generic'
CC [M]=20
/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.o
/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.c:=
=20
In function 'ieee80211_frame_allowed':
/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.c:=
1198:=20
error: 'ETH_P_PAE' undeclared (first use in this function)
/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.c:=
1198:=20
error: (Each undeclared identifier is reported only once
/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.c:=
1198:=20
error: for each function it appears in.)
make[3]: ***=20
[/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211/rx.o=
]=20
Error 1
make[2]: ***=20
[/home/karol/tmp/downloads/compat-wireless-2008-09-26/net/mac80211] Err=
or 2
make[1]: ***=20
[_module_/home/karol/tmp/downloads/compat-wireless-2008-09-26] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-4-generic'


--=20
Karol Szkudlarek
Mikronika
ul. Wykopy 2/4
60-001 POZNA=C3=91
tel. +48 61 6655600
fax +48 61 6655602
e-mail karol@mikronika.com.pl

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
