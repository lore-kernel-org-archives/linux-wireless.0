Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:60817 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578Ab3CCEAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Mar 2013 23:00:16 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20786.51827.829167.296365@gargle.gargle.HOWL> (sfid-20130303_050021_420157_48A79121)
Date: Sun, 3 Mar 2013 09:28:43 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <51325FC2.4060604@openwrt.org>
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
	<51325FC2.4060604@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> I just sent some minstrel_ht improvements to linux-wireless@
> Please test if they fix the throughput delta in your setup. In my tests
> they visibly reduce the number of unnecessary fallbacks to lower rates.

With the fixes, the avg. TX throughput crept up to 188 Mbps, but I ran
ath9k-rc once again and obtained 197 Mbps. There were lots of 200+ Mbps
max. throughput too.

This is not a synthetic benchmark with shield boxes, attenuators etc.,
just a simple over-the-air test with not much interference, so a gap of
~10 Mbps is somewhat surprising.

Sujith
