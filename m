Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab3DVNru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 09:47:50 -0400
Message-ID: <1366638465.8637.14.camel@jlt4.sipsolutions.net> (sfid-20130422_154754_412324_78E998A8)
Subject: Re: [PATCH v2 1/2] mac80211: minstrel_ht: pick only supported rates
 for sta and group max*rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>,
	Felix Fietkau <nbd@openwrt.org>
Date: Mon, 22 Apr 2013 15:47:45 +0200
In-Reply-To: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com> (sfid-20130418_143103_744723_2BA10740)
References: <1366287981-24134-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20130418_143103_744723_2BA10740)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-04-18 at 14:26 +0200, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> minstrel_ht initializes max_tp_rate max_tp_rate2 and max_prob_rate to
> zero both for minstrel_ht_sta and minstrel_mcs_group_data.
> This is wrong since there is no guarantee that the 1st rate of any
> group is supported.

Applied both.

johannes

