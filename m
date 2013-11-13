Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:47790 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab3KMWLo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Nov 2013 17:11:44 -0500
Message-ID: <5283F91D.3070205@openwrt.org> (sfid-20131113_231147_149008_3DD5EDBF)
Date: Wed, 13 Nov 2013 23:11:41 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2] mac80211: minstrel_ht: fix rates selection
References: <5283ED31.1050606@openwrt.org> <1384380427-12950-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1384380427-12950-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-11-13 23:07, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> When initializing rates selections starting indexes upon stats update,
> the minstrel_sta->max_* rates should be 'group * MCS_GROUP_RATES + i'
> not 'i'. This affects settings where one of the peers does not support
> any of the rates of the group 0 (i.e. when ht_cap.mcs.rx_mask[0] == 0).
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

