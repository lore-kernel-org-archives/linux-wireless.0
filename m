Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60020 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3BOPn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 10:43:58 -0500
Message-ID: <1360943029.15040.20.camel@jlt4.sipsolutions.net> (sfid-20130215_164400_801062_59F224FC)
Subject: Re: [PATCH] mac80211: enable vif.cab_queue for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: thomas@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, Bob Copeland <bob@cozybit.com>
Date: Fri, 15 Feb 2013 16:43:49 +0100
In-Reply-To: <1360941514-9579-1-git-send-email-me@bobcopeland.com> (sfid-20130215_161930_899883_2EAFE24E)
References: <1360941514-9579-1-git-send-email-me@bobcopeland.com>
	 (sfid-20130215_161930_899883_2EAFE24E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-15 at 10:18 -0500, Bob Copeland wrote:
> Since mesh powersaving was added, pending bcast/mcast frames may go out the
> CAB queue now.  Unfortunately, the queue was only set up for AP mode, so we
> would try to tx on the IEEE80211_INVAL_HW_QUEUE.  Allow cab_queue for mesh
> interfaces as well.

Applied.

johannes

