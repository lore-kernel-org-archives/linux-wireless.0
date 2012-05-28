Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7624 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2E1HP4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 03:15:56 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20419.9719.160216.124618@gargle.gargle.HOWL> (sfid-20120528_091559_199110_00CCE286)
Date: Mon, 28 May 2012 12:45:03 +0530
To: Adrian Chadd <adrian@freebsd.org>
CC: Ben Greear <greearb@candelatech.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: Anyone doing WiFi throughput tests?
In-Reply-To: <CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com>
References: <4FC04B5A.1070900@candelatech.com>
	<20416.19680.571601.549629@gargle.gargle.HOWL>
	<4FC0F8CE.1030303@candelatech.com>
	<20417.972.888113.821079@gargle.gargle.HOWL>
	<20417.1857.115550.807746@gargle.gargle.HOWL>
	<4FC2437C.9090106@candelatech.com>
	<CAJ-Vmon13Q5icGU0oeQWaOaHF+jfhEZHyK2Y1xp5BwCgM_74pg@mail.gmail.com>
	<4FC2F73F.4070701@candelatech.com>
	<CAJ-VmonMtRUZpidJERT7hRUDJNgyoMdVovXoG5WdStH6zk7yFQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> Ah, Osprey is AR93xx series stuff. Well, not strictly speaking, but
> that "family."
> 
> I'd have to go and check what the current state of all the latest 11n
> chips are. Luis, Sujith and Felix would know better than I; I'm still
> stuck in the land of AR92xx in FreeBSD (at least for the next few
> weeks.)

ath9k has good support for the AR9003 family - AR9380 based devices, that is.
And the numbers that I posted were with a XB112, which uses AR9380. 

> Also, FreeBSD on 2x2 (AR9160) hostap:
> 
> 
> TCP sta -> hostap:
> 
> [SUM]  0.0-10.0 sec    178 MBytes    149 Mbits/sec
> 
> UDP sta -> hostap:
> 
> 
> [ ID] Interval       Transfer     Bandwidth       Jitter   Lost/Total Datagrams
> [  3]  0.0-10.1 sec    274 MBytes    228 Mbits/sec  0.135 ms 17045/212291 (8%)
> 
> TCP is around the expected spot, but I've seen it around 160MBit in
> the past. I think I messed up something with BAR/TX scheduling. The
> UDP RX is likely another scheduling issue; I seem to be occasionally
> overflowing the RX descriptor list.

Well, 228 Mbps is much more reasonable. :)

Sujith
