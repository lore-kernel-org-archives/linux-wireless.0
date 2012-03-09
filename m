Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49195 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757437Ab2CIE6e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 23:58:34 -0500
Received: from [50.47.233.138] (50-47-233-138.evrt.wa.frontiernet.net [50.47.233.138])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id q294wXOi008150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 8 Mar 2012 20:58:33 -0800
Message-ID: <4F598DF8.1040608@candelatech.com> (sfid-20120309_055840_499306_26985BCD)
Date: Thu, 08 Mar 2012 20:58:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Any reason not to implement ethtool stats for wifi (ath9k)?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now, to get error counters it seems you have to grub
through debugfs files.  Is there any reason we can't implement
ethtool stats for wifi devices?

I'm thinking that the interface specific errors (retries, etc)
could be reported, as well as the radio's errors (CRC, framing, etc).

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
