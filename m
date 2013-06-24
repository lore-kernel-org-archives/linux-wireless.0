Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37739 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3FXTAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 15:00:10 -0400
Date: Mon, 24 Jun 2013 14:45:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-06-24
Message-ID: <20130624184520.GD1997@tuxdriver.com> (sfid-20130624_210036_550575_53C6D021)
References: <1372094678.8439.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372094678.8439.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 24, 2013 at 07:24:38PM +0200, Johannes Berg wrote:
> John,
> 
> As can be expected, I've accumulated a bunch more patches. Much of it is
> already trending towards fixes rather than new features, but some of
> those are there as well. I've removed the diffstat because git got
> confused about it, presumably because I merged mac80211 to resolve a
> conflict with the nl80211 fix. Anyway ...
> 
> Here we have a few memory leak fixes related to BSS struct handling
> mostly from Ben, including a fix for a more theoretical problem
> (associating while a BSS struct times out) from myself, a compilation
> warning fix from Arend, mesh fixes from Thomas, tracking the beacon
> bitrate (Alex), a bandwidth change event fix (Ilan) and some initial
> work for 5/10 MHz channels from Simon.
> 
> Let me know if there are any issues.
> 
> johannes
> 
> 
> The following changes since commit 795d855d56c6d172f50a974f603ba923ac93ee76:
> 
>   mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 6c7c4cbfd5f59c04a40af67ad72d14e19215ef36:
> 
>   mac80211: initialize power mode for mesh STAs (2013-06-24 15:59:20 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
