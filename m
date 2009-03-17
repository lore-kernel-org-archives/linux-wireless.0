Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46746 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756019AbZCQRPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 13:15:36 -0400
Date: Tue, 17 Mar 2009 13:05:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Possible circular locking problem
Message-ID: <20090317170530.GE6737@tuxdriver.com> (sfid-20090317_181551_557471_29822BAE)
References: <49BFCCC5.9080500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <49BFCCC5.9080500@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 11:16:05AM -0500, Larry Finger wrote:
> While testing usage of b43legacy as an AP, I got the following in my logs. My
> kernel is the latest wireless-testing that was pulled about 2 hours ago -
> hostapd is 0.6.8.

I think Johannes may have already posted a patch that addresses the
cfg80211 vs. rtnl locking (or I could be wrong).  I'll try to get
another round of patches merged sometime today.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
