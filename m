Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:56781 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333Ab3IESR1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Sep 2013 14:17:27 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r85IHQJm005698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 5 Sep 2013 11:17:26 -0700
Message-ID: <5228CAB6.5060308@candelatech.com> (sfid-20130905_201730_285012_56AFEB61)
Date: Thu, 05 Sep 2013 11:17:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Specifying priority for management frames?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While debugging a problem with group-rekeys, we noticed that the sniffer (on external machine)
reported management packets are sent in the best-effort QoS queue.

It seems to me that these should be in the VO queue instead, or at least
we should be able to specify the queue in supplicant when sending the frames?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

