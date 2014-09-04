Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47247 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754698AbaIDRPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 13:15:13 -0400
Date: Thu, 4 Sep 2014 13:09:55 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-08-29
Message-ID: <20140904170955.GC3467@tuxdriver.com> (sfid-20140904_191557_218305_7FB0E6C1)
References: <1409309659.4577.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409309659.4577.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 29, 2014 at 12:54:19PM +0200, Johannes Berg wrote:
> John,
> 
> Please excuse how late I'm sending this. Hopefully it can still go in.
> 
> Note that the tag is signed :)
> 
> johannes
> 
> 
> The following changes since commit c9d26423e56ce1ab4d786f92aebecf859d419293:
> 
>   Merge tag 'pm+acpi-3.17-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2014-08-14 18:13:46 -0600)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git tags/mac80211-for-john-2014-08-29
> 
> for you to fetch changes up to 14b058bbce9279ee432f0944ca14df69f4a0d170:
> 
>   mac80211: fix agg_status debugfs file alignment (2014-08-26 11:13:37 +0200)
> 
> ----------------------------------------------------------------
> Here are a few fixes for mac80211. One has been discussed for a while
> and adds a terminating NUL-byte to the alpha2 sent to userspace, which
> shouldn't be necessary but since many places treat it as a string we
> couldn't move to just sending two bytes.
> 
> In addition to that, we have two VLAN fixes from Felix, a mesh fix, a
> fix for the recently introduced RX aggregation offload, a revert for
> a broken patch (that luckily didn't really cause any harm) and a small
> fix for alignment in debugfs.
> 
> ----------------------------------------------------------------
> Bob Copeland (1):
>       mac80211: mesh_plink: handle confirm frames with new plid
> 
> Denton Gentry (1):
>       mac80211: fix start_seq_num in Rx reorder offload
> 
> Eliad Peller (1):
>       regulatory: add NUL to alpha2
> 
> Felix Fietkau (2):
>       mac80211: ignore AP_VLAN in ieee80211_recalc_chanctx_chantype
>       mac80211: fix smps mode check for AP_VLAN
> 
> Johannes Berg (2):
>       Revert "mac80211: disable uAPSD if all ACs are under ACM"
>       mac80211: fix agg_status debugfs file alignment

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
