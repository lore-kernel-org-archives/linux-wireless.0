Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:36793 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab3CAVX2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Mar 2013 16:23:28 -0500
Received: by mail-we0-f173.google.com with SMTP id r5so2870101wey.18
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2013 13:23:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5130CAAE.8070807@candelatech.com>
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
	<5130CAAE.8070807@candelatech.com>
Date: Fri, 1 Mar 2013 13:23:26 -0800
Message-ID: <CAJ-VmokStTkOp-UYp7UwNLy8KfeyP0sQvuA1_fm5Ji6pkV8a7w@mail.gmail.com> (sfid-20130301_222339_320553_B3CB6BCF)
Subject: Re: [RFC] ath9k: remove ath9k_rate_control
From: Adrian Chadd <adrian@freebsd.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Sujith Manoharan <sujith@msujith.org>,
	Felix Fietkau <nbd@openwrt.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	Paul Stewart <pstew@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 March 2013 07:35, Ben Greear <greearb@candelatech.com> wrote:

> I assume UDP would be good, or is TCP traffic preferred?
> (In our tests, we see significantly more throughput with
> UDP than TCP, even when we hacked on TCP ack delay).
>
> Is wireless-testing the preferred tree to test against?

Do both. Failures at higher MCS rates -> extra latency -> TCP backoff
-> crappier throughput.



Adrian
