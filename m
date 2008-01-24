Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24896 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYAXLIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 06:08:35 -0500
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	John Linville <linville@tuxdriver.com>
Subject: Re: mac80211 does seem to have a netdev refcount bug
References: <200801241148.25456.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 24 Jan 2008 13:07:07 +0200
In-Reply-To: <200801241148.25456.mb@bu3sch.de> (ext Michael Buesch's message of "Thu\, 24 Jan 2008 11\:48\:25 +0100")
Message-ID: <87ejc7a3dw.fsf@nokia.com> (sfid-20080124_110839_013596_C433B08B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> There seems to be a netdevice refcounting (freeing) bug in mac80211.
> I frequently see the "waiting for netdev to become free, refcount = 1"
> message on rmmod. I don't remember the message text exactly, but I think you
> know what I mean.

Most probably it's this one:

http://bugzilla.kernel.org/show_bug.cgi?id=9778

There was a discussion on netdev about this. Not a mac80211 bug AFAIK.

-- 
Kalle Valo
