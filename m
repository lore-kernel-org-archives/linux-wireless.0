Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56046 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab3AaAdT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 19:33:19 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r0V0XIbN027684
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 16:33:18 -0800
Message-ID: <5109BBCE.4090605@candelatech.com> (sfid-20130131_013327_719098_EEE7630A)
Date: Wed, 30 Jan 2013 16:33:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any way to see current CQM RSSI value?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm seeing lots of these types of wireless events:

2013-01-30 16:30:59.330  1.1:  sta2 (phy #0): connection quality monitor event: RSSI went below threshold
2013-01-30 16:30:59.330  1.1:  sta4 (phy #0): connection quality monitor event: RSSI went below threshold
2013-01-30 16:30:59.330  1.1:  sta6 (phy #0): connection quality monitor event: RSSI went below threshold
2013-01-30 16:31:03.380  1.1:  sta3 (phy #0): connection quality monitor event: RSSI went below threshold
2013-01-30 16:31:06.342  1.1:  sta5 (phy #0): connection quality monitor event: RSSI went below threshold
2013-01-30 16:31:06.360  1.1:  sta7 (phy #0): connection quality monitor event: RSSI went below threshold

As far as I can tell, nothing on my system is setting the cqm (at least, it's not
using 'iw' to do it).

Is there any way to dump out the current cqm RSSI value?  If not, maybe it's
worth adding?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

