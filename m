Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42872 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab3CHVAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Mar 2013 16:00:22 -0500
Date: Fri, 8 Mar 2013 15:53:22 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-03-07
Message-ID: <20130308205322.GB402@tuxdriver.com> (sfid-20130308_220029_045660_03A98D4F)
References: <1362649836.8694.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362649836.8694.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 07, 2013 at 10:50:36AM +0100, Johannes Berg wrote:
> Hi John,
> 
> First mac80211-next pull request, and I already have quite a bit of work
> in there ...
> 
> First, I merged mac80211/master to avoid some conflicts. This brings in
> a bunch of fixes you're already familiar with. For real -next material,
> I have a whole bunch of minstrel work, minstrel_ht from Felix and legacy
> minstrel from Thomas (Huehn). The other Thomas (Pedersen) did a number
> of changes in mesh to allow userspace peering management even when the
> mesh isn't secured. Stanislaw changes suspend/resume to always
> disconnect the networks. This is typically already done by
> network-manager so won't make a huge difference for most users, but
> fixes a number problems, particularly with USB drivers that can easily
> disconnect while suspended. Ilan has a small change to allow mac80211
> drivers to differentiate remain-on-channel reasons, and Jouni extends
> nl80211 to allow fast roaming with full-MAC devices. I have a fairly
> large number of patches as well, many of them fairly simple cleanups,
> but also allowing split wiphy dumps and adding back the full wiphy
> information in nl80211, station entry change checking and more VHT work
> including VHT capability overrides (mostly for testing purposes).
> 
> Let me know if there are any issues.
> 
> johannes
> 
> The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:
> 
>   Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 87f59c70ce6d1abeaaf97594835be29f746b81a0:
> 
>   mac80211: init mesh timer for user authed STAs (2013-03-06 16:36:14 +0100)
 
Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
