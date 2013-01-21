Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43886 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab3AURre (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2013 12:47:34 -0500
Message-ID: <1358790474.5190.6.camel@jlt4.sipsolutions.net> (sfid-20130121_184737_700042_65E52F17)
Subject: Re: [PATCH 3/3] cfg80211: move world roaming check for beacon hints
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 21 Jan 2013 18:47:54 +0100
In-Reply-To: <50FD7D34.4050203@candelatech.com>
References: <1355943184-966-1-git-send-email-mcgrof@do-not-panic.com>
	  <1355943184-966-4-git-send-email-mcgrof@do-not-panic.com>
	  (sfid-20121219_200036_196307_E48D6F1B) <1356628591.15149.14.camel@jlt4.sipsolutions.net>
	 <50FD7D34.4050203@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-01-21 at 09:39 -0800, Ben Greear wrote:
> On 12/27/2012 09:16 AM, Johannes Berg wrote:
> > On Wed, 2012-12-19 at 10:53 -0800, Luis R. Rodriguez wrote:
> >> From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
> >>
> >> We should not add new beacon hints even if the wiphy
> >> is not world roaming. Without this we were always adding
> >> a beacon hint if not world roaming for every non world
> >> roaming wiphy interface.
> >
> > This introduced a locking bug, lockdep splat below. I'm going to drop
> > the series for my pull request, please respin.
> 
> Were new patches ever posted for this?

I fixed it and applied the patches.

johannes

