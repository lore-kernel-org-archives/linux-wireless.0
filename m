Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45939 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3CBFkQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 00:40:16 -0500
Received: by mail-wi0-f180.google.com with SMTP id hi8so234114wib.13
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 21:40:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20785.24998.602035.570736@gargle.gargle.HOWL>
References: <1360329197-72631-1-git-send-email-nbd@openwrt.org>
	<20757.1753.863278.858198@gargle.gargle.HOWL>
	<511508A6.8020104@openwrt.org>
	<CAMcMvsjE=NNqt_q=vepZbFE8vwLypN2qZwyXg=aCBj3vvYOpMw@mail.gmail.com>
	<51152D9E.1040106@openwrt.org>
	<20130227192030.GW12537@pogo>
	<CAJ-VmonSQi1SZVrkvcuS8dubqSAy8s1RCGJounL1EA23z3FXzw@mail.gmail.com>
	<512ECE01.8010102@openwrt.org>
	<20782.54505.239733.82364@gargle.gargle.HOWL>
	<512EDDC5.7020901@openwrt.org>
	<20784.48093.263373.125536@gargle.gargle.HOWL>
	<CAJ-Vmon8B=wUkSd5tq=e-2FoUZykv28TD+tR71+-1R0W9_hYew@mail.gmail.com>
	<20785.24998.602035.570736@gargle.gargle.HOWL>
Date: Fri, 1 Mar 2013 21:40:14 -0800
Message-ID: <CAJ-Vmokn4A7nQdOHa4iJU=mP6_VEfHn8nYB1fsDiUhbZ1Z2mwQ@mail.gmail.com> (sfid-20130302_064021_507980_78B6B1F9)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 March 2013 18:19, Sujith Manoharan <sujith@msujith.org> wrote:
> Adrian Chadd wrote:
>> (190mbit TCP on 2-stream? Damn. Looks like I have a little more
>> optimisation to do in FreeBSD. I'm only hitting 160/170mbit TCP on
>> AR9280<->AR9280 and AR9280<->AR9287. But I hit 220-240mbit UDP.)
>
> I used a AR9462 card for this test. With AR9280/AR9287 I get abysmal
> numbers with both rate control algorithms. Maybe something has regressed
> in ath9k for the AR9002 family...

It's almost like we need some kind of lab space set aside for running
regression tests with all of the ath9k hardware ,dating back to
AR5416, with some automated testing rigs..

I have the hardware. Who wants to do it? :)



adrian
