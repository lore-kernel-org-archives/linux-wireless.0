Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62133 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab2E0CYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 May 2012 22:24:07 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20417.36878.491297.428459@gargle.gargle.HOWL> (sfid-20120527_042441_674763_9FDB45B7)
Date: Sun, 27 May 2012 07:53:10 +0530
To: Ben Greear <greearb@candelatech.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] Anyone doing WiFi throughput tests?
In-Reply-To: <4FC18E6E.4020707@candelatech.com>
References: <4FC04B5A.1070900@candelatech.com>
	<CAJ-VmomRv-GdRooL=1G5avxAqJ4h3eoAfNkzYit3ok-fXmd25A@mail.gmail.com>
	<20417.35821.91808.2702@gargle.gargle.HOWL>
	<20417.36056.95300.690329@gargle.gargle.HOWL>
	<4FC18E6E.4020707@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> On 05/26/2012 07:09 PM, Sujith Manoharan wrote:
> > Sujith Manoharan wrote:
> >> Odd. I get low numbers with a DB120 running OpenWRT (git HEAD).
> >>
> >> TCP TX - ~260 Mbps.
> >> TCP RX - ~160 Mbps.
> >>
> >> UDP RX - ~240 Mbps.
> >> UDP TX - iperf borks and doesn't display anything.
> 
> Maybe NAT won't let it through, if this is coming downstream?

Ah yes, OpenWRT has default iptables rules - I'll check.

> For that matter, from what perspective is the TX or RX?

I was using the ath9k station as the test unit, so:

STA->AP is TX.
AP->STA is RX.

Sujith
