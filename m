Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51710 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab3CAPf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 10:35:26 -0500
Message-ID: <5130CAAE.8070807@candelatech.com> (sfid-20130301_163530_168379_B440C1D9)
Date: Fri, 01 Mar 2013 07:35:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Felix Fietkau <nbd@openwrt.org>, Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20782.54505.239733.82364@gargle.gargle.HOWL> <512EDDC5.7020901@openwrt.org> <20784.48093.263373.125536@gargle.gargle.HOWL>
In-Reply-To: <20784.48093.263373.125536@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/01/2013 06:31 AM, Sujith Manoharan wrote:
> Felix Fietkau wrote:
>> What was the distance and what was the rate used?
>
> A distance of about a meter between the AP and STA.
>
> AP:  DB120 - running an internal build.
> STA: WB222 - wireless-testing HEAD.
> Signal is about -43 dBm.
> Channel 40, HT40-
>
> I've attached sample runs with minstrel_ht and ath9k-rc. With minstrel_ht,
> the numbers fluctuate between 180 and 190 Mbps and the average throughput
> varies each time (185, 186 etc.). With ath9k-rc, it's 195+ always.

We can run some tests through attenuators today.

I assume UDP would be good, or is TCP traffic preferred?
(In our tests, we see significantly more throughput with
UDP than TCP, even when we hacked on TCP ack delay).

Is wireless-testing the preferred tree to test against?

Thanks,
Ben

>
> Sujith
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

