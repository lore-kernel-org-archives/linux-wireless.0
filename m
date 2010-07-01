Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42710 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab0GAVCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Jul 2010 17:02:07 -0400
Received: from [71.117.12.23] (pool-71-117-12-23.sttlwa.dsl-w.verizon.net [71.117.12.23])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id o61KUZJn021379
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 1 Jul 2010 13:30:36 -0700
Message-ID: <4C2CFAEB.9070302@candelatech.com>
Date: Thu, 01 Jul 2010 13:30:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Question on 'iw reg get/set'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm using an ath9k NIC on a slightly hacked 2.6.34 kernel, Fedora 13 32-bit.
I'm using the stock 'iw' command that comes with Fedora 13.

As far as I can tell, the results of 'iw reg get'
are funky:

[root@atom lanforge]# iw reg get
country 98:
	(2402 - 2472 @ 40), (N/A, 20)
	(5170 - 5250 @ 20), (N/A, 17)
	(5250 - 5330 @ 20), (N/A, 18), DFS

What is '98'?  It doesn't correspond to anything I can find
in the numeric or ascii lists of country codes.

Also, setting the domain doesn't seem to do anything, although
there are no errors:

[root@atom lanforge]# iw reg get
country 98:
	(2402 - 2472 @ 40), (N/A, 20)
	(5170 - 5250 @ 20), (N/A, 17)
	(5250 - 5330 @ 20), (N/A, 18), DFS
[root@atom lanforge]# iw reg set US
[root@atom lanforge]# iw reg get
country 98:
	(2402 - 2472 @ 40), (N/A, 20)
	(5170 - 5250 @ 20), (N/A, 17)
	(5250 - 5330 @ 20), (N/A, 18), DFS

Anyone know if this is *supposed* to work?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
