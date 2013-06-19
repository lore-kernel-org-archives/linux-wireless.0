Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38135 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757362Ab3FSTPI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 15:15:08 -0400
Date: Wed, 19 Jun 2013 15:05:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-06-19
Message-ID: <20130619190518.GE12079@tuxdriver.com> (sfid-20130619_211513_285274_B72835E2)
References: <1371659691.8349.24.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1371659691.8349.24.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 19, 2013 at 06:34:51PM +0200, Johannes Berg wrote:
> Hi John,
> 
> One more ...
> 
> This is just the fix for the nl80211_fam.attrbuf race Linus ran into and
> analysed.
> 
> johannes
> 
> The following changes since commit 795d855d56c6d172f50a974f603ba923ac93ee76:
> 
>   mac80211: Fix rate control mask matching call (2013-06-12 09:12:43 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 3a5a423bb958ad22eeccca66c533e85bf69ba10e:
> 
>   nl80211: fix attrbuf access race by allocating a separate one (2013-06-19 18:31:20 +0200)
> 
> ----------------------------------------------------------------
> Johannes Berg (1):
>       nl80211: fix attrbuf access race by allocating a separate one
> 
>  net/wireless/nl80211.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
