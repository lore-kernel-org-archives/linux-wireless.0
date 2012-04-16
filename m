Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37108 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab2DPXpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 19:45:02 -0400
Received: from [192.168.100.111] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q3GNj1Xa021152
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 16:45:01 -0700
Message-ID: <4F8CAEFD.7060005@candelatech.com> (sfid-20120417_014544_780018_5A6A1D08)
Date: Mon, 16 Apr 2012 16:45:01 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Cannot rmmod ath9k in 3.4.0-rc3+ (wireless-testing)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath9k module has refcnt of 1, but
nothing in /sys/modules/ath9k/holders/

[root@ct520-6157 lanforge]# rmmod ath9k
ERROR: Module ath9k is in use

I don't recall having this issue in -rc2...will bisect
in a day or two if no one beats me to it.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

