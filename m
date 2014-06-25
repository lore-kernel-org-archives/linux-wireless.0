Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54334 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144AbaFYSaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 14:30:11 -0400
Date: Wed, 25 Jun 2014 14:19:48 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-06-24
Message-ID: <20140625181948.GB3445@tuxdriver.com> (sfid-20140625_203016_462277_A058E8EE)
References: <1403619592.10831.9.camel@jlt4.sipsolutions.net>
 <1403627007.10831.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403627007.10831.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2014 at 06:23:27PM +0200, Johannes Berg wrote:
> On Tue, 2014-06-24 at 16:19 +0200, Johannes Berg wrote:
> > Hi John,
> > 
> > Due to travel etc. I've been a little slow this cycle, but we do have a
> > few fixes that should go into the current rc series ...
> > 
> > We have a fix from Eliad for a time calculation, a fix from Max for
> > head/tailroom when sending authentication packets, a revert that Felix
> > requested since the patch in question broke regulatory and a fix from
> > myself for an issue with a new command that we advertised in the wrong
> > place.
> > 
> > Let me know if there are any issues.
> 
> Well this was pretty stupid ... here's the actual pull request.
> 
> johannes
> 
> 
> The following changes since commit 7171511eaec5bf23fb06078f59784a3a0626b38f:
> 
>   Linux 3.16-rc1 (2014-06-15 17:45:28 -1000)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git HEAD
> 
> for you to fetch changes up to 02df00eb0019e7d15a1fcddebe4d020226c1ccda:
> 
>   nl80211: move set_qos_map command into split state (2014-06-24 16:13:10 +0200)
> 
> ----------------------------------------------------------------
> Eliad Peller (1):
>       cfg80211: fix elapsed_jiffies calculation
> 
> Johannes Berg (2):
>       Revert "cfg80211: Use 5MHz bandwidth by default when checking usable channels"
>       nl80211: move set_qos_map command into split state
> 
> Max Stepanov (1):
>       mac80211: WEP extra head/tail room in ieee80211_send_auth

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
