Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36250 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912Ab3CERNl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 12:13:41 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r25HDe1x022147
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Tue, 5 Mar 2013 09:13:40 -0800
Message-ID: <513627C4.5040207@candelatech.com> (sfid-20130305_181354_797069_B9B9553F)
Date: Tue, 05 Mar 2013 09:13:40 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Stations disconnected due to no activity in latest wireless-testing.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying the 3.9.0-rc1-wl+, and wlan0 is disconnecting almost immediately
after it connects, supposedly because of inactivity....

Is this a known issue?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

