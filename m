Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta19.adelphia.net ([68.168.78.226]:40243 "EHLO
	mta19.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbXLLLF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 06:05:29 -0500
Received: from [127.0.0.1] (really [69.204.11.190]) by mta9.adelphia.net
          (InterMail vM.6.01.05.02 201-2131-123-102-20050715) with ESMTP
          id <20071212003911.CQY3002.mta9.adelphia.net@[127.0.0.1]>
          for <linux-wireless@vger.kernel.org>;
          Tue, 11 Dec 2007 19:39:11 -0500
Message-ID: <475F2DAD.4000708@roadrunner.com> (sfid-20071212_110544_110578_F8FBB681)
Date: Tue, 11 Dec 2007 19:39:09 -0500
From: Randy Cushman <rcushman_linux@roadrunner.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: BCM4306 Questions
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently I retrofitted my older HP laptop with a "Broadcom 802.11b/g 
WLAN" miniPCI adapter.  The adapter works well with Windows XP.  Now I 
would like to be able to use the adapter with Linux.

Question:  Is there any hope of using this adapter with a native driver, 
or should I use ndiswrapper?  Requirement:  I want to be able to connect 
to networks using WPA-PSK.

Complication:  Neither bcm43xx-fwcutter nor b43-fwcutter recognizes the 
latest driver I found at HP.  I figure it would be best for me to use 
this firmware because this is the only driver that I have found to be 
stable.

Question:  Could someone instruct a mere applications software engineer 
on how to determine the values to insert into fwcutter_list.h to support 
this driver (or provide documentation to this effect)?

Details:
- BCM-4306 -based adapter.  Vendor 14E4, Device 4320, Subsys 12F8103C, 
Rev 03
- HP driver SP36684.EXE, v4.150.29.0 (7/11/2007) (BCMWL5.SYS)
- unstable driver tried: v4.100.15.5
- openSUSE 10.3 installed bcm43xx-fwcutter and loaded modules bcm43xx 
and ieee80211_softmac

Randy Cushman

