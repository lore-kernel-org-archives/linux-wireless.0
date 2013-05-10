Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36382 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3EJMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 08:09:27 -0400
Message-ID: <1368187764.8390.14.camel@jlt4.sipsolutions.net> (sfid-20130510_140930_964596_EA99F585)
Subject: Re: [RFC 0/4] cfg80211/mac80211: simplify locking
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Date: Fri, 10 May 2013 14:09:24 +0200
In-Reply-To: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net> (sfid-20130510_140823_865843_217BECE5)
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130510_140823_865843_217BECE5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 14:08 +0200, Johannes Berg wrote:
> I got a little fed up with all the locking, and decided to simplify.
> 
> This should still work, but I've only done some very simple tests.
> I'm hoping it'll fix some of the weird corner cases that Ben and
> others have found, which may be due to different locks in different
> cases and things racing against each other ... I'm not convinced it
> really will though, but hey, who knows :)

Of course, this is also always a good thing:

 24 files changed, 322 insertions(+), 803 deletions(-)

johannes

