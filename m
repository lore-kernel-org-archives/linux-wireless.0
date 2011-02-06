Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:36869 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab1BFTBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 14:01:25 -0500
Received: from [71.112.48.101] (pool-71-112-48-101.sttlwa.dsl-w.verizon.net [71.112.48.101])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p16J1OX0027157
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 6 Feb 2011 11:01:25 -0800
Message-ID: <4D4EF004.3040109@candelatech.com>
Date: Sun, 06 Feb 2011 11:01:24 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Scanning and channel types.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Current code always sets the channel type to NO_HT when scanning.

 From what I can tell, we should be able to send NO_HT packets on
any channel type, and for passive scanning, it should not matter
at all what channel-type we are using.

I tested relaxing scanning to use the current channel type
when scanning on the operating channel, and it seems to
work.

Does anyone see any problems with this approach?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
