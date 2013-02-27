Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40710 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758678Ab3B0XND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 18:13:03 -0500
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r1RND1Ik012036
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 15:13:02 -0800
Message-ID: <512E92FD.2090106@candelatech.com> (sfid-20130228_001314_338433_42408E0E)
Date: Wed, 27 Feb 2013 15:13:01 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Interesting behaviour when AP enables/disables HT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was doing some tests where I change the AP's configuration
(enable/disable HT, enable/disable HT40, etc) on a somewhat
hacked 3.7.9+ kernel.

One thing I noticed is that if stations are associated using /a,
but I quickly reconfigure the AP to use /a/n mode (ie HT enabled),
the stations stay in 'no-ht' mode.

If I down/up the stations, they come up in HT mode.

Just a curiosity at this point...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

