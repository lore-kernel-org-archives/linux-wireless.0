Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57941 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161044Ab2COShF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 14:37:05 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q2FIb4ro005848
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 11:37:04 -0700
Message-ID: <4F6236D0.40505@candelatech.com> (sfid-20120315_193710_650107_511DE533)
Date: Thu, 15 Mar 2012 11:37:04 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: compiler warning in wireless-testing.
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like this is the compiler's fault to me..but might be
worth explicitly initializing the sta variable just to make
it quiet.

   CC [M]  net/mac80211/mlme.o
/home/greearb/git/linux.wireless-testing/net/mac80211/mlme.c: In function ‘ieee80211_prep_connection’:
/home/greearb/git/linux.wireless-testing/net/mac80211/mlme.c:3058: warning: ‘sta’ may be used uninitialized in this function
   CC [M]  net/mac80211/debugfs.o
   CC [M]  net/mac80211/debugfs_netdev.o

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

