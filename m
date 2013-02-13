Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51593 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab3BMOcT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:32:19 -0500
Message-ID: <1360765934.8868.14.camel@jlt4.sipsolutions.net> (sfid-20130213_153227_079587_3F99A296)
Subject: Re: [PATCH] mac80211: start auth/assoc timeout on frame status
From: Johannes Berg <johannes@sipsolutions.net>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Feb 2013 15:32:14 +0100
In-Reply-To: <511BA1E5.40402@neratec.com>
References: <1359638935-16613-1-git-send-email-johannes@sipsolutions.net>
	   (sfid-20130131_142837_609017_1B1D23D2) <1359992600.10311.25.camel@jlt4.sipsolutions.net>
	  <511B9807.6000200@neratec.com>
	 <1360765274.8868.13.camel@jlt4.sipsolutions.net>
	 <511BA1E5.40402@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-13 at 15:23 +0100, Wojciech Dubowik wrote:

> >> I have seen it before in my testing and it gets
> >> a lot worse with system load.  Sometimes it can
> >> retry auth/assoc frames for 10 seconds before
> >> connecting.
> >> Anyway it always looses the first authentication frame.
> > I think I see what's happening -- can you try this patch?
> >
> > http://p.sipsolutions.net/61f4271fed0e446b.txt
> >
> I have tried and it doesn't do timeout anymore. I will continue
> testing with more load.

Ok. I just realized that it needs to receive frames for this to happen,
which may not happen here because my environment is quiet.

Let me know, I'll also try to test a bit more.

johannes

