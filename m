Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47237 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab2J2RGM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 13:06:12 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q9TH6BJL021910
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 10:06:11 -0700
Message-ID: <508EB783.9080000@candelatech.com> (sfid-20121029_180616_165655_39B11451)
Date: Mon, 29 Oct 2012 10:06:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any thoughts on how to best shield u.fl connectors on NICs?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It appears hard to get well-shielded u.fl (IPEX) to SMA pigtails, and all of the
modern ath9k NICs I've seen use u.fl connectors on the NIC.

I have found a vendor that will do double-shielded 1.32mm cable, and I have some of those
on order, but the way u.fl connectors are made it seems there is always a bit of un-shielded
cable where the connector is crimped onto the cable.

I am curious if anyone has any suggestions or experience with connecting u.fl NICs to
SMA cables in a highly shielded manner...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

