Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-1-a-1.mail.uk.tiscali.com ([212.74.100.52]:1313 "EHLO
	mk-filter-1-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752931AbZIXTps (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 15:45:48 -0400
Date: Thu, 24 Sep 2009 20:45:45 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253816614.3868.406.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
 <1253816614.3868.406.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 24 Sep 2009, Johannes Berg wrote:
> 
> Ah. That patch isn't in yet I guess. I wonder if that could still be an
> issue though. Maybe you can try that patch along with this one:
> 
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=55a00b83339f25d2979b85ab6e2151390327db80;hp=cfa53f1e753ed709f0a483fa8bd16bc7d08d402d

I've now tried recent Linus -git plus both those patches on both machines,
but no joy on either.

> 
> Anyhow, I'm grasping at straws -- can you tell me more about the failure
> mode, and possibly enable CONFIG_MAC80211_DEBUG_MENU and
> CONFIG_MAC80211_VERBOSE_DEBUG?

I enabled those on both machines for that trial, will keep them on for now.

The failure mode is that iwconfig says ESSID:off/any instead of showing
my essid, and I've no connectivity; but you probably need something more
specific than that.

I'll send you privately the .config of each machine, and the dmesg of
each machine, from that trial.  I've just compared the .configs against
what works for 2.6.31, and everything relevant still seems to be there.

I do wonder if this is an openSUSE interaction, whether another distro
with the same kernel would be fine.

Hugh
