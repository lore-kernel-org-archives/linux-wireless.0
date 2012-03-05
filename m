Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173009pub.verizon.net ([206.46.173.9]:55318 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2CESHn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 13:07:43 -0500
Received: from vznit170080 ([unknown] [172.18.12.131])
 by vms173009.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0M0F000UQ8WBIVY1@vms173009.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Mon, 05 Mar 2012 11:07:24 -0600 (CST)
Date: Mon, 05 Mar 2012 11:07:23 -0600 (CST)
From: alupu@verizon.net
To: Larry.Finger@lwfinger.net
Cc: linux-wireless@vger.kernel.org
Message-id: <5847319.2627837.1330967243216.JavaMail.root@vznit170080> (sfid-20120305_190750_023629_4BF7946B)
Subject: r8712u staging in kernel 3.2.9
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

System: (B)LFS i686-pc-linux-gnu, 3.2.9
Rosewill Wireless Adapter: RNX-N180UBE

I compiled (as part of kernel 3.2.9) the r8712u module.
Comes up OK but cannot take an essid nor a key.


Example:
iwconfig wlan0 essid <ESSID> key restricted  <Encryption key>


Fails quietly:
iwconfig wlan0

wlan0 unassociated Nickname:"rtl_wifi"
Mode:Managed Access Point: Not-Associated Sensitivity:0/0
Retry:off RTS thr:off Fragment thr:off
Encryption key:off
...

FWIW, it does take a mode ("managed", as shown above - default was Auto)

I'd appreciate your help.


Thanks,
-- Alex 
