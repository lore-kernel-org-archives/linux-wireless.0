Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:60574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3KQJbO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Nov 2013 04:31:14 -0500
Message-ID: <1384680671.14795.14.camel@jlt4.sipsolutions.net> (sfid-20131117_103119_857568_8ECDFAAE)
Subject: Re: [PATCH v2] mac80211: minstrel_ht: fix rates selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Date: Sun, 17 Nov 2013 10:31:11 +0100
In-Reply-To: <1384380427-12950-1-git-send-email-karl.beldan@gmail.com> (sfid-20131113_230744_598344_1E46DF40)
References: <5283ED31.1050606@openwrt.org>
	 <1384380427-12950-1-git-send-email-karl.beldan@gmail.com>
	 (sfid-20131113_230744_598344_1E46DF40)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-13 at 23:07 +0100, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When initializing rates selections starting indexes upon stats update,
> the minstrel_sta->max_* rates should be 'group * MCS_GROUP_RATES + i'
> not 'i'. This affects settings where one of the peers does not support
> any of the rates of the group 0 (i.e. when ht_cap.mcs.rx_mask[0] == 0).

Applied.

johannes

