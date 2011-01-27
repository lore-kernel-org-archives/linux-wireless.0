Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42997 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab1A0XH4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 18:07:56 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p0RN7ton025810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 15:07:56 -0800
Message-ID: <4D41FACB.2010807@candelatech.com>
Date: Thu, 27 Jan 2011 15:07:55 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Multiple vifs and HT v/s non-HT.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We found something fun while playing with HT mode:

We had some vifs associated with an AP with HT enabled,
and other VIFS to an AP with HT disabled.

They managed to associate, but with slow rates and
for whatever reason, nothing is able to send traffic.
I would have expected one set or the other would
be able to send traffic.

The ath9k hardware ended up in HT mode according to
ath9k debugfs wiphy file, but that was probably
just luck.

I'm not too sure how to ensure this mixed-mode HT
scenario doesn't happen at this point...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

