Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49492 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1EJQeG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 12:34:06 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p4AGY5YZ004663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 09:34:05 -0700
Message-ID: <4DC968FD.1040906@candelatech.com> (sfid-20110510_183410_534198_98692F3F)
Date: Tue, 10 May 2011 09:34:05 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath5k and ath9k bugs still in 2.6.39-rc7
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As far as I can tell, ath5k is critically broken due to un-initilized
spinlock (fixed in the patch I posted a few days ago), and ath9k stations
won't work due to PS bugs that Felix posted fixes for yesterday.

It looks like -rc7 is the last RC before the final .39, so I'm hoping
these patches can be pushed quickly to Linus!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

