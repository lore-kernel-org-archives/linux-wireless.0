Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:38350 "EHLO ds10.mine.nu"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbYGZQ5L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Jul 2008 12:57:11 -0400
Message-ID: <488B5736.1080401@openwrt.org> (sfid-20080726_185714_452320_5DEBE2AE)
Date: Sat, 26 Jul 2008 18:56:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: =?ISO-8859-1?Q?C=E9dric_Auger?= <cedric@grisbi.org>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl3945 slow for downloading
References: <20080726161140.59041730@grisbi.org> <488B3969.4050405@openwrt.org> <488B48C1.6090506@lwfinger.net>
In-Reply-To: <488B48C1.6090506@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Just for comparison, my BCM4312 running b43 from the latest wireless-testing 
> gets the following tcpperf throughput:
> 
> AP Mode          TX          RX
> 
> Mixed b/g    19.8 MB/s   23.0 MB/s
> g-only       20.5 MB/s   23.1 MB/s
> 
> For these tests, the connecting end was wired to the router. The difference in 
> TX speeds was about what I expected - the small difference in RX speeds was not. 
> In any case, if you see a large difference with iwl3945, that would be useful 
> information.
On the laptop that I mentioned, this problem was only happening sometimes.
I did not figure out what actually triggered it.
Most of the time the throughput was similar to what you posted here,
but when it went down, it went down right to 100-120 KB/s

Could it be that this is triggered by the use b/g protection mode due to reception
of foreign beacons of B devices by the AP? Has anybody tested RTS/CTS in detail?

- Felix
