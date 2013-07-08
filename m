Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39097 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GHSOw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 14:14:52 -0400
Message-ID: <1373307283.8312.16.camel@jlt4.sipsolutions.net> (sfid-20130708_201455_910098_D360253F)
Subject: Re: [PATCH] iw: Add support for mesh peer link expiration.
From: Johannes Berg <johannes@sipsolutions.net>
To: Colleen Twitty <colleen@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Date: Mon, 08 Jul 2013 20:14:43 +0200
In-Reply-To: <1373303058-4229-1-git-send-email-colleen@cozybit.com> (sfid-20130708_190426_886272_7F98D16B)
References: <1373303058-4229-1-git-send-email-colleen@cozybit.com>
	 (sfid-20130708_190426_886272_7F98D16B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-07-08 at 10:04 -0700, Colleen Twitty wrote:
> User can configure the peer link expiration time with a
> new mesh parameter, mesh_plink_timeout.  This parameter
> sets the expiration time, in seconds, for peer links.
> After this time, the peer link is expired.  This means the
> inactive STA is removed from the list of peers and is not
> considered a peer again unless it re-peers.

Applied.

johannes

