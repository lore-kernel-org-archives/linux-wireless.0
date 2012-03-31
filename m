Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59739 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab2CaD4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 23:56:32 -0400
Received: from [50.47.233.138] (50-47-233-138.evrt.wa.frontiernet.net [50.47.233.138])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q2V3uV68007537
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 20:56:31 -0700
Message-ID: <4F76806E.2010101@candelatech.com> (sfid-20120331_055635_558966_95EF378B)
Date: Fri, 30 Mar 2012 20:56:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Why is throughput so bad with lots of virtual stations?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I notice that when I get, say, 200 virtual stations on a radio (ath9k),
the total throughput becomes about 100 packets per second.  It can run
several thousands of packets per second with 10 or so stations.

According to the xmit debugfs file, the radio is basically idle.
It's queues are empty almost all of the time, few retransmits, etc.

This is on the 3.0.26 kernel.

If anyone has any ideas of what might need work, please let me know.

I'll start digging into the code to see what I can see.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
