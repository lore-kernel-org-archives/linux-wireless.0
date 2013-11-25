Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38407 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809Ab3KYP4a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 10:56:30 -0500
Message-ID: <1385394988.4443.26.camel@jlt4.sipsolutions.net> (sfid-20131125_165633_128312_FEB83894)
Subject: Re: [PATCH v2] mac80211: use capped prob when computing throughputs
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Mon, 25 Nov 2013 16:56:28 +0100
In-Reply-To: <1384971215-16302-1-git-send-email-karl.beldan@gmail.com> (sfid-20131120_191430_736650_8E9F6DFC)
References: <1384971215-16302-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131120_191430_736650_8E9F6DFC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-20 at 19:13 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
> introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
> it to compute the per rate throughput.

Applied.

johannes

