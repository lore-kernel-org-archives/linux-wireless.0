Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:35766 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaC1EWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2014 00:22:00 -0400
Received: from [192.168.2.15] ([12.218.212.2])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id s2S4LxtJ012255
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 27 Mar 2014 21:22:00 -0700
Message-ID: <5334F8E7.1070803@candelatech.com> (sfid-20140328_052231_504026_EEC32353)
Date: Thu, 27 Mar 2014 21:21:59 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Setting txpower fails?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Any idea why this isn't working?

Kernel is 3.9.11+, driver is ath9k.

[root@ct523-9292 lanforge]# iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
           Retry short limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off

[root@ct523-9292 lanforge]# iwconfig wlan0 txpower 10
[root@ct523-9292 lanforge]# echo $?
0
[root@ct523-9292 lanforge]# iwconfig wlan0
wlan0     IEEE 802.11abgn  ESSID:off/any
           Mode:Managed  Access Point: Not-Associated   Tx-Power=16 dBm
           Retry short limit:7   RTS thr:off   Fragment thr:off
           Encryption key:off
           Power Management:off

[root@ct523-9292 lanforge]#

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

