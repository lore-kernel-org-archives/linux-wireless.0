Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-97.dex002.intermedia.net ([64.78.19.89]:29971 "EHLO
	DHOST002-97.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932536AbXC2QZw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 12:25:52 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Thu, 29 Mar 2007 08:48:48 -0700
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jiri Benc <jbenc@suse.cz>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: optimise ieee80211_get_hdrlen
Message-ID: <20070329154848.GB3906@devicescape.com>
References: <1175011305.9282.10.camel@johannes.berg> <20070328191116.GJ6036@devicescape.com> <1175166447.8807.38.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1175166447.8807.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 29, 2007 at 01:07:27PM +0200, Johannes Berg wrote:
> On Wed, 2007-03-28 at 12:11 -0700, Jouni Malinen wrote:

> > Is this case even used anywhere? Looks like unnecessary optimization at
> > the cost of making the source code more difficult to understand and
> > modify.
> 
> Not sure. I tested in userspace with a program that simply tried all
> possible values.

At least originally, there were no need for processing any control
frames which is why asked this.. I haven't looked whether any of the new
hardware drivers have needs for processing them.

-- 
Jouni Malinen                                            PGP id EFC895FA
