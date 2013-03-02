Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59488 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303Ab3CBUXo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 15:23:44 -0500
Message-ID: <51325FC2.4060604@openwrt.org> (sfid-20130302_212347_937116_0C4ABEAB)
Date: Sat, 02 Mar 2013 21:23:30 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org> <20757.1753.863278.858198@gargle.gargle.HOWL> <511508A6.8020104@openwrt.org> <CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com> <51152D9E.1040106@openwrt.org> <20130227192030.GW12537@pogo> <CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com> <512ECE01.8010102@openwrt.org> <20782.54505.239733.82364@gargle.gargle.HOWL> <512EDDC5.7020901@openwrt.org> <20784.48093.263373.125536@gargle.gargle.HOWL>
In-Reply-To: <20784.48093.263373.125536@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-01 3:31 PM, Sujith Manoharan wrote:
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
I just sent some minstrel_ht improvements to linux-wireless@
Please test if they fix the throughput delta in your setup. In my tests
they visibly reduce the number of unnecessary fallbacks to lower rates.

Thanks,

- Felix
