Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42569 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3BOTPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:15:10 -0500
Date: Fri, 15 Feb 2013 14:06:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2012-02-15
Message-ID: <20130215190600.GC4981@tuxdriver.com> (sfid-20130215_201515_748396_E154FED9)
References: <1360874926.8210.28.camel@jlt4.sipsolutions.net>
 <1360918340.8622.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360918340.8622.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 15, 2013 at 09:52:20AM +0100, Johannes Berg wrote:
> Hi John,
> 
> Sorry the resend/rebase -- Fengguang Wu's build testing found a
> kernel-doc error ... (I guess I should run that myself)
> 
> Please pull to get
>  * radar detection work from Simon
>  * mesh improvements from Thomas
>  * a connection monitoring/powersave fix from Wojciech
>  * TDLS-related station management work from Jouni
>  * VLAN crypto fixes from Michael Braun
>  * CCK support in minstrel_ht from Felix
>  * an SMPS (not SMSP, oops) related improvement in mac80211 (Emmanuel)
>  * some WoWLAN work from Amitkumar Karwar: pattern match offset and a
>    documentation fix
>  * some WoWLAN work from myself (TCP connection wakeup feature API)
>  * and a lot of VHT (and some HT) work (also from myself)
> 
> And a number of more random cleanups/fixes. I merged mac80211/master to
> avoid a merge problem there.
> 
> johannes
> 
> 
> The following changes since commit 9c35d7d2368f54313b988a01c408e5cf863ffd9e:
> 
>   mac80211: Add flushes before going off-channel (2013-02-11 22:52:21 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 93c78c5debeb9c7101ecc73347d4730c26a98c05:
> 
>   mac80211_hwsim: ask mac80211 to reserve space for chanctx.drv_priv (2013-02-15 09:41:45 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
