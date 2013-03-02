Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:54468 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab3CBCUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 21:20:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20785.24998.602035.570736@gargle.gargle.HOWL> (sfid-20130302_032100_306206_707E0D9D)
Date: Sat, 2 Mar 2013 07:49:18 +0530
To: Adrian Chadd <adrian@freebsd.org>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <CAJ-Vmon8B=wUkSd5tq=e-2FoUZykv28TD+tR71+-1R0W9_hYew@mail.gmail.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adrian Chadd wrote:
> (190mbit TCP on 2-stream? Damn. Looks like I have a little more
> optimisation to do in FreeBSD. I'm only hitting 160/170mbit TCP on
> AR9280<->AR9280 and AR9280<->AR9287. But I hit 220-240mbit UDP.)

I used a AR9462 card for this test. With AR9280/AR9287 I get abysmal
numbers with both rate control algorithms. Maybe something has regressed
in ath9k for the AR9002 family...

Sujith
