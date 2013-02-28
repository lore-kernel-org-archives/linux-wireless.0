Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:45096 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3B1FKU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2013 00:10:20 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20782.58980.730523.353167@gargle.gargle.HOWL> (sfid-20130228_061033_174650_236D6DF0)
Date: Thu, 28 Feb 2013 10:38:52 +0530
To: Felix Fietkau <nbd@openwrt.org>
Cc: Adrian Chadd <adrian@freebsd.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
In-Reply-To: <512EDDC5.7020901@openwrt.org>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix Fietkau wrote:
> What was the distance and what was the rate used?

The station was about a meter away from the AP. I don't have the rcstats,
debugfs was compiled out. I'll rerun the test and post the results.

Sujith
