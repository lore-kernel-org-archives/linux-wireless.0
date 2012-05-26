Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38043 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab2EZHoo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 03:44:44 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20416.35246.76971.129331@gargle.gargle.HOWL> (sfid-20120526_094448_207545_03F70750)
Date: Sat, 26 May 2012 13:13:42 +0530
To: Joe Semler <josef.semler@gmail.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Ben Greear <greearb@candelatech.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
In-Reply-To: <7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<7759D07D-C2C8-48D8-8F44-687C7E85D188@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Semler wrote:
> > With a XB112 card (3x3) in HT40 mode, 5Ghz, TX throughput (TCP) can reach 290 Mbps.
> > Sample iperf run:
> > 
> > [  3] 28.0-29.0 sec  34.1 MBytes   286 Mbits/sec
> > [  3] 29.0-30.0 sec  34.6 MBytes   290 Mbits/sec
> > [  3] 30.0-31.0 sec  34.8 MBytes   292 Mbits/sec
> > [  3] 31.0-32.0 sec  34.8 MBytes   292 Mbits/sec
> > [  3] 32.0-33.0 sec  34.9 MBytes   293 Mbits/sec
> 
> Do you use ath9k for that purpouse? I was thinking our driver is not able to operate MIMO.
> Some changes that i missed?

Yes, those numbers are with ath9k, with latest wireless-testing.

Sujith
