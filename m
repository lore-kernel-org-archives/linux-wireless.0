Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934566Ab3FSO1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:27:47 -0400
Message-ID: <1371652060.8349.22.camel@jlt4.sipsolutions.net> (sfid-20130619_162750_542253_76255CCD)
Subject: Re: [PATCH 1/6] wireless:  Add memory usage debugging.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 16:27:40 +0200
In-Reply-To: <51C1BE8D.4020307@candelatech.com>
References: <1371593017-10985-1-git-send-email-greearb@candelatech.com>
	  (sfid-20130619_000356_212228_4AEA7C87) <1371635381.8349.9.camel@jlt4.sipsolutions.net>
	 <51C1BE8D.4020307@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-06-19 at 07:22 -0700, Ben Greear wrote:
> > I'm not really sure this is worth it -- you found the bug with
> > kmemleak() after all. Having very specific things for all of this
> > doesn't really seem worth it.
> 
> kmemleak didn't show the bss leaking though, so I spent several days
> thinking ies pointers were being corrupted somehow.  I think the code
> is not that intrusive, and since drivers also take bss refs, the problems
> could come back in the future.

Fair enough, I'll think about it some more. I don't think drivers are
really that much of a problem though.

> I didn't actually audit the drivers since I am not using that hardware,
> by the way.

Right.

> I started porting some patches to wireless-next yesterday..think that
> would be a good enough tree to patch against?

Probably OK, I only have few patches right now. I also just posted two
patches to address parts of this problem though, can you review those
too?

johannes

