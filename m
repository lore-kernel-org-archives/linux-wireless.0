Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38007 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969Ab3KTHck (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 02:32:40 -0500
Message-ID: <528C6590.1000803@openwrt.org> (sfid-20131120_083257_063400_8F602521)
Date: Wed, 20 Nov 2013 08:32:32 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH] mac80211: use capped prob when computing throughputs
References: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1384908668-27869-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-20 01:51, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> Commit 3e8b1eb "mac80211/minstrel_ht: improve rate selection stability"
> introduced a local capped prob in minstrel_ht_calc_tp but omitted to use
> it to compute the rate throughput.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
> CC: Felix Fietkau <nbd@openwrt.org>
Nice catch!
Acked-by: Felix Fietkau <nbd@openwrt.org>

