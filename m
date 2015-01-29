Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48333 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314AbbA2QF5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Jan 2015 11:05:57 -0500
Message-ID: <1422547553.6322.18.camel@sipsolutions.net> (sfid-20150129_170601_603042_26BE6659)
Subject: Re: [PATCH] nl80211: don't document per-wiphy interface dump
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 29 Jan 2015 17:05:53 +0100
In-Reply-To: <6CBE8643-DD96-45AB-9F73-4CADC7FD2277@holtmann.org>
References: <1422546796-22526-1-git-send-email-johannes@sipsolutions.net>
	 <6CBE8643-DD96-45AB-9F73-4CADC7FD2277@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-01-29 at 08:02 -0800, Marcel Holtmann wrote:

> > Such a feature doesn't exist and isn't really needed since you
> > probably won't have enough interfaces to make it worthwhile, so
> > just remove that from the documentation.

> we had a TODO item internally that planned to implement this actually.

I'm not sure what it buys you since you still have to deal with old
kernels and do the filtering, and there aren't that many messages
(typically you only have one NIC anyway), but hey, if you have enough
time to waste on it I guess I don't mind ... Although we should start
watching nl80211.c code size a bit more I guess :)

Can always include a revert of this in the change that actually adds it.

johannes


