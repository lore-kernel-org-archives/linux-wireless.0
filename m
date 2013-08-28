Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36728 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335Ab3H1SAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 14:00:13 -0400
Date: Wed, 28 Aug 2013 13:51:01 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-08-27
Message-ID: <20130828175059.GC1966@tuxdriver.com> (sfid-20130828_200017_732923_336457E3)
References: <1377593647.20012.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1377593647.20012.2.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 27, 2013 at 10:54:07AM +0200, Johannes Berg wrote:
> John,
> 
> I know it's late, but I have one straggler for the current cycle. If you
> don't want to pull it any more, I guess it's not terribly important as
> it only affects some APs (though those are affected badly and no
> connection is possible.)
> 
> This patch fixes a regression with associating to some broken APs that
> send an ECSA IE in their probe responses.
> 
> johannes
> 
> The following changes since commit 75a423f493ffdf741acae27bf179cd560f7813d7:
> 
>   mac80211: ibss: fix ignored channel parameter (2013-08-21 15:33:08 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to d70b7616d9080ec9f868fbd31db5fd4341435d61:
> 
>   mac80211: ignore (E)CSA in probe response frames (2013-08-23 17:05:12 +0200)
> 
> ----------------------------------------------------------------
> Johannes Berg (1):
>       mac80211: ignore (E)CSA in probe response frames
> 
>  net/mac80211/mlme.c | 11 +++--------
>  1 file changed, 3 insertions(+), 8 deletions(-)

It looks nice to have, but not necessary for 3.11 -- I'll pull it
into wireless-next...

John

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
