Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:41850 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZCTPag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2009 11:30:36 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2009 08:30:35 -0700
Date: Fri, 20 Mar 2009 07:29:57 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 3/6] mac80211: check if HT40+/- is allowed before
	sending assoc
Message-ID: <20090320142957.GA8120@tesla> (sfid-20090320_163039_795162_10DBC68F)
References: <1237444886-24530-1-git-send-email-lrodriguez@atheros.com> <1237546136.5100.147.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1237546136.5100.147.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2009 at 03:48:56AM -0700, Johannes Berg wrote:
> On Thu, 2009-03-19 at 02:41 -0400, Luis R. Rodriguez wrote:
> > We weren't checking this at all.
> 
> The question is whether we really want that. In other places, we trust
> the AP, why not here as well?

Its not about trust its also about if it will logistically make sense, for
example you simply cannot use HT40- on channel 11 if yuo don't have
a channel 7. The NO_HT40- would indicate this to us so we don't bother.
The example I give is lousy as its not something that would occur usually
but with 5 GHz and regulatory rules changing things could be a bit
different.

> 
> johannes


  Luis
