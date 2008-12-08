Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:29995 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301AbYLIEHv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 23:07:51 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 20:07:51 -0800
Date: Mon, 8 Dec 2008 12:08:06 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Dan E <trg_info@mailhaven.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: CRDA question
Message-ID: <20081208200806.GI6035@tesla> (sfid-20081209_050754_604592_DFB30461)
References: <1228454249.2652.1288380409@webmail.messagingengine.com> <43e72e890812042132y6b676a1ucf446a678e1d8a81@mail.gmail.com> <1228515313.30577.1288527655@webmail.messagingengine.com> <20081206001956.GE5926@tesla> <1228687013.25070.1288752601@webmail.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1228687013.25070.1288752601@webmail.messagingengine.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Dec 07, 2008 at 01:56:53PM -0800, Dan E wrote:
> 
> On Fri, 5 Dec 2008 16:19:56 -0800, "Luis R. Rodriguez" wrote:
> 
> > If you have actual issues to point out then please point them out or
> > better yet just send a patch for the solution.
> 
> Indeed.  I envision an alternative scheme that can be optionally
> selected as part of a "reduced footprint for embedded systems" patch
> set/git branch, but that's a ways off.

Keep in mind CRDA was designed with this in mind, you can already do it,
its why we let you customize your database and build your own CRDA. If
you're doing embedded you could just put together a database of the
things you wnat to support. You can also customize it further if you
have customer RFs for example which operate in strange licensed
frequencies too.

The database we provide is just what is used regularly throughout the
world for normal 802.11n operation.

> [OT: Is it correct to reply TO your email addy and CC the list address,
> or is it better to "Reply All"?  I have to install a real email client
> and ditch the webmail interface soon for git purposes.]

It doesn't matter.

  Luis
