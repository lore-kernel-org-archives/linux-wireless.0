Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41802 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbaJTJEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2014 05:04:30 -0400
Received: by mail-pd0-f174.google.com with SMTP id y13so4598303pdi.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Oct 2014 02:04:29 -0700 (PDT)
Message-ID: <5444CF6B.9020309@gmail.com> (sfid-20141020_110438_562284_E4696FFB)
Date: Mon, 20 Oct 2014 14:31:31 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: Karl Beldan <karl.beldan@rivierawaves.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH v4 0/4] add VHT support to minstrel_ht
References: <1413652424-14345-5-git-send-email-karl.beldan@gmail.com> <1413795342-11995-1-git-send-email-karl.beldan@gmail.com>
In-Reply-To: <1413795342-11995-1-git-send-email-karl.beldan@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Karl Beldan,

On 10/20/2014 02:25 PM, Karl Beldan wrote:
> From: Karl Beldan <karl.beldan@rivierawaves.com>
>
> Hi,
>
> This is just a respin rebased on v2 of "mac80211: minstrels: fix buffer
> overflow in HT debugfs" which only affects 4/4.
>
> Karl Beldan (4):
>    mac80211: minstrel_ht: Increase the range of handled rate indexes
>    mac80211: minstrel_ht: macros adjustments for future VHT_GROUPs
>    mac80211: minstrel_ht: include type (cck/ht) in rates flag
>    mac80211: minstrel_ht: add basic support for VHT rates <= 3SS@80MHz
> v2:
> - typo in Kconfig
> - adjust room in debugfs rc_stats buffer
> - add a module param to mix ht rates with vht ones
> - default to 3SS instead of 2SS (with "mac80211: minstrel_ht: macros
>    adjustments for future VHT_GROUPs")
> - use common MINSTREL_MAX_STREAMS both for VHT and HT so that we can get
>    rid of the 'MINSTREL_MAX_STREAMS >= 3' checks for minstrel_mcs_groups
> v3:
> - put module param *vht_only* under CONFIG_MAC80211_RC_MINSTREL_VHT
> v4:
> - rebase on v2 of "mac80211: minstrels: fix buffer overflow in HT debugfs rc_stats"
>
>   net/mac80211/Kconfig                       |   7 +
>   net/mac80211/rc80211_minstrel_ht.c         | 292 +++++++++++++++++++++++------
>   net/mac80211/rc80211_minstrel_ht.h         |  38 +++-
>   net/mac80211/rc80211_minstrel_ht_debugfs.c |  32 ++--
>   4 files changed, 290 insertions(+), 79 deletions(-)
>
Check patch errors on this series.. run checkpatch.pl on this series.

-- 
Regards,
Varka Bhadram.

