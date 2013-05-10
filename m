Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3EJO1N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 10:27:13 -0400
Message-ID: <1368196028.8390.18.camel@jlt4.sipsolutions.net> (sfid-20130510_162721_054162_B62A4BEF)
Subject: Re: [RFC 0/4] cfg80211/mac80211: simplify locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 10 May 2013 16:27:08 +0200
In-Reply-To: <518D0390.90006@candelatech.com>
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
	 <518D0390.90006@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 07:26 -0700, Ben Greear wrote:
> On 05/10/2013 05:08 AM, Johannes Berg wrote:
> > I got a little fed up with all the locking, and decided to simplify.
> >
> > This should still work, but I've only done some very simple tests.
> > I'm hoping it'll fix some of the weird corner cases that Ben and
> > others have found, which may be due to different locks in different
> > cases and things racing against each other ... I'm not convinced it
> > really will though, but hey, who knows :)
> 
> I'm stacked high with tasks at the moment, but will try to
> run this through some testing soon.
> 
> These are in your tree?

In the wip branch, for now.

johannes

