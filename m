Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab2HTLZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:25:32 -0400
Message-ID: <1345461929.4459.15.camel@jlt3.sipsolutions.net> (sfid-20120820_132536_460564_B18AD893)
Subject: Re: [PATCH v2 1/2] mac80211: use skb_queue_walk() in
 mesh_path_assign_nexthop
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:25:29 +0200
In-Reply-To: <1344561340-32409-1-git-send-email-thomas@cozybit.com> (sfid-20120810_031554_581256_6C24D840)
References: <1344561340-32409-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120810_031554_581256_6C24D840)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-09 at 18:15 -0700, Thomas Pedersen wrote:
> Since all we really want is just to iterate over all skbs, do just that
> and avoid (de)queueing to a clusmy tmpq.

Ok ... replaced with these, what was the difference anyway? :)

johannes

