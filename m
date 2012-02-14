Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46443 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab2BNIbA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 03:31:00 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20282.7088.898987.229335@gargle.gargle.HOWL> (sfid-20120214_093105_218259_BA9EABCD)
Date: Tue, 14 Feb 2012 14:00:40 +0530
To: Peter Stuge <peter@stuge.se>
CC: Ben Greear <greearb@candelatech.com>,
	<ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>,
	<linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [PATCH 3/7] ath9k: Merge wiphy and misc debugfs files
In-Reply-To: <20120214073855.6843.qmail@stuge.se>
References: <20280.43962.403799.188541@gargle.gargle.HOWL>
	<4F3947A1.2060103@candelatech.com>
	<20281.48485.409968.741657@gargle.gargle.HOWL>
	<4F39BF5F.3030408@candelatech.com>
	<20281.52354.478076.479135@gargle.gargle.HOWL>
	<20120214073855.6843.qmail@stuge.se>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peter Stuge wrote:
> It is not very wise for ath9k to reduce debug output with the
> motivation that some users leave it enabled even if they deploy
> into limited systems and they would actually prefer to have less
> debugging.
> 
> If ath9k users have an issue with debugging being too big then THEY
> can disable it. It seems senseless to delete debugging when the
> driver is clearly still buggy.
> 
> It also seems senseless to try to punt to mac80211. It is amazing
> that Ben's point is not absolutely obvious.
> 
> One purpose of debugging is to allow and enable consistency checking.
> Redundant information is by definition neccessary for that.
> 
> 
> As a compromise, you could suggest a move to a two-level compile time
> option for debugging. You would enable only what you believe to be
> adequate for debugging in production systems (wait, what did I just
> write? oh well..) with the first option, and you would allow the rest
> of the world to enable complete debugging with the second option.

/me disregards all the nerd-rage and the general snarkiness.

Having multiple levels of debugging makes things complex. If the general
consensus is to keep the information, I can rework the patch.

Sujith

