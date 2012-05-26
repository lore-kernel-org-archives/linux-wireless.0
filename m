Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17374 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2EZDZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 May 2012 23:25:19 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20416.19680.571601.549629@gargle.gargle.HOWL> (sfid-20120526_052554_530852_F8139138)
Date: Sat, 26 May 2012 08:54:16 +0530
To: Ben Greear <greearb@candelatech.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Anyone doing WiFi throughput tests?
In-Reply-To: <4FC04B5A.1070900@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> We've been doing some tests using Atheros stations and various APs.  The max throughput
> we've seen so far is about 237Mbps (received UDP payload on the stations).
> (Open-Air, AP about 5 feet away, 3x3 MIMO, HT40, 5Ghz, etc).
> 
> We are still running lots of different permutations, but I am interested if
> anyone else has any numbers to share (official or otherwise).

Which card/chip ?

With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP) can reach 290 Mbps.
Sample iperf run:

[  3] 28.0-29.0 sec  34.1 MBytes   286 Mbits/sec
[  3] 29.0-30.0 sec  34.6 MBytes   290 Mbits/sec
[  3] 30.0-31.0 sec  34.8 MBytes   292 Mbits/sec
[  3] 31.0-32.0 sec  34.8 MBytes   292 Mbits/sec
[  3] 32.0-33.0 sec  34.9 MBytes   293 Mbits/sec

Sujith
