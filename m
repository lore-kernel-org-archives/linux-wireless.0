Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56790 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0ENH75 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 03:59:57 -0400
Subject: Re: Possible issue with mac80211 and certain access points
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Chad Koehler <chad.koehler@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1273788460.375.76.camel@localhost.localdomain>
References: <AANLkTim6GiiFR0zWVqlmIJr-sk1ThwO3GAA97aJwWg3U@mail.gmail.com>
	 <1273788460.375.76.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 09:59:54 +0200
Message-ID: <1273823994.3865.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-05-14 at 00:07 +0200, Marcel Holtmann wrote:

> > Using the Palm Pre hotspot, I can get connected, but the connection
> > will drop after a very short period of time.  There are messages in
> > the system log whenever the connection drops:

> actually I ran into the same issue two days ago and was going to post
> it. So what I am seeing with the Palm Pre is that when we actually scan
> while connected to the Palm Pre, a second later we end up disconnected.

So the Palm is acting as an AP? A beer for each of you says their AP
implementation is buggy.

johannes

