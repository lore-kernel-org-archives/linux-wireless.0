Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41556 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbaJRR37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Oct 2014 13:29:59 -0400
Message-ID: <5442A390.8040401@openwrt.org> (sfid-20141018_193018_634496_CFECE6F2)
Date: Sat, 18 Oct 2014 19:29:52 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] add VHT support to minstrel_ht
References: <1413575459-29612-5-git-send-email-karl.beldan@gmail.com> <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1413652424-14345-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-10-18 19:13, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
> 
> 
> Karl Beldan (4):
>   mac80211: minstrel_ht: Increase the range of handled rate indexes
>   mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
>   mac80211: minstrel_ht: include type (cck/ht) in rates flag
>   mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
> v2:
> - typo in Kconfig
> - adjust room in debugfs rc_stats buffer
> - add a module param to mix ht rates with vht ones
> - default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
>   adjustments for future VHT_GROUPs")
> - use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
>   rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups
> v3:
> - put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
Acked-by: Felix Fietkau <nbd@openwrt.org>
