Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33407 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab2BOErF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 23:47:05 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20283.14537.284629.215476@gargle.gargle.HOWL> (sfid-20120215_054711_466326_2D4EF1C6)
Date: Wed, 15 Feb 2012 10:17:05 +0530
To: Ben Greear <greearb@candelatech.com>
CC: <ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
In-Reply-To: <4F3AAB3F.7030308@candelatech.com>
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
	<4F3947A1.2060103@candelatech.com>
	<20281.48485.409968.741657@gargle.gargle.HOWL>
	<4F39BF5F.3030408@candelatech.com>
	<20281.52354.478076.479135@gargle.gargle.HOWL>
	<20120214073855.6843.qmail@stuge.se>
	<20282.7088.898987.229335@gargle.gargle.HOWL>
	<4F3A9ACB.3010009@candelatech.com>
	<20282.43026.335779.405152@gargle.gargle.HOWL>
	<4F3AAB3F.7030308@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear wrote:
> I was thinking about adding a method that grabbed as many registers
> as I have info for and dumping them with printk when DMA errors
> hit.  This would make kernel splats more useful.
> 
> And also have a debugfs file called 'registers' or similar that one
> could cat out and get similar info.  And this can let folks look
> at steady-state or whatever.
> 
> But, the logic to turn the register bit values into strings would
> be in the driver (and thus add some code size bloat).
> 
> My hope is that this would allow a better chance of understanding
> the stop-DMA errors that some people get reliably (but which I can never reliably
> reproduce).
> 
> I'm not sure how that plays into your 'event log' idea, but maybe
> one will help the other.

I was thinking more on the lines of instrumentation, but what you are
describing here looks like a VERBOSE_DEBUG option is needed.

Sujith
