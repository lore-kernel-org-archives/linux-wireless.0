Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33016 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaB1SpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Feb 2014 13:45:14 -0500
Date: Fri, 28 Feb 2014 13:43:53 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-02-28
Message-ID: <20140228184352.GH30876@tuxdriver.com> (sfid-20140228_194519_299908_1930D4A5)
References: <1393595772.4133.6.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1393595772.4133.6.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 28, 2014 at 02:56:12PM +0100, Johannes Berg wrote:
> John,
> 
> It's getting later in the rc cycle, and the pull requests are getting
> smaller, but we still have some fixes...
> 
> This time I have a fix to get out of an 'infinite error state' in case
> regulatory domain updates failed and two fixes for VHT associations: one
> to not disconnect immediately when the AP uses more bandwidth than the
> new regdomain would allow after a change due to association country
> information getting used, and one for an issue in the code where
> mac80211 doesn't correctly ignore a reserved field and then uses an HT
> instead of VHT association.
> 
> Please let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit e3685e03b40f5ec7926d9a75bf63467fc4071df9:
> 
>   mac80211: fix station wakeup powersave race (2014-02-20 11:54:09 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to cb664981607a6b5b3d670ad57bbda893b2528d96:
> 
>   mac80211: fix association to 20/40 MHz VHT networks (2014-02-27 20:53:01 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
