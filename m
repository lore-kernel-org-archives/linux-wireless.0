Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52945 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964858Ab3E1RpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 13:45:09 -0400
Date: Tue, 28 May 2013 13:39:10 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-05-27
Message-ID: <20130528173909.GF2084@tuxdriver.com> (sfid-20130528_194514_974895_76A5D4C5)
References: <1369646928.8229.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369646928.8229.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 27, 2013 at 11:28:48AM +0200, Johannes Berg wrote:
> Hi John,
> 
> Another pull request for 3.10 with a number of fixes.
> 
> This time I have a fix from Stanislaw for a stupid mistake I made in the
> auth/assoc timeout changes, a fix from Felix for 64-bit traffic counters
> and one from Helmut for address mask handling in mac80211. I also have a
> few fixes myself for four different crashes reported by a few people.
> 
> Please let me know if there are any issues.
> 
> johannes
> 
> 
> The following changes since commit e248ad30204eff6559b4d2d94d49d9d46c08185a:
> 
>   cfg80211: fix sending WoWLAN TCP wakeup settings (2013-05-16 22:38:09 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to ac20976dcaeea3e77e40e9aac8f3799d2a22ea2b:
> 
>   mac80211: Allow single vif mac address change with addr_mask (2013-05-27 11:26:48 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
