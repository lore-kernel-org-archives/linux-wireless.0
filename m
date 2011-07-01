Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59641 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139Ab1GAIKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 04:10:49 -0400
Subject: Re: Crash in mlme.c, wireless-testing 2.6.39-wl + hacks
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4E0CECDD.7040409@candelatech.com>
References: <4E0CE929.7040300@candelatech.com>
	 (sfid-20110630_232253_480125_B86CAA5E) <1309469454.3873.0.camel@jlt3.sipsolutions.net>
	 <4E0CECDD.7040409@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Jul 2011 10:10:46 +0200
Message-ID: <1309507846.3888.1.camel@jlt3.sipsolutions.net> (sfid-20110701_101054_242542_AE97E192)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Very little significant changes in this area, but I've a non-related
> proprietary module loaded, and patches to various other parts of the
> networking code.
> 
> The full tree is here if you want to take a look, or I can send
> you a full unified diff:
> 
> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux.wireless-testing-ct.ct/.git;a=summary

Fair enough, I don't see anything there that would impact this bug.

> Seems a tricky timing related bug, possibly we're only hitting it because
> we're testing on an older C3 processor system that is significantly slower
> than our normal test systems.

Hm. That seems odd. I didn't see anything that lacked locking either.

I think the detail that we need to investigate is what you said before:

> configured for in-kernel authentication,
> re-configure them for supplicant, let them associate, delete one of
> them.

but I don't see anything there either right now.

johannes

