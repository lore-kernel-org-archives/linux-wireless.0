Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36293 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab2HTLY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 07:24:27 -0400
Message-ID: <1345461864.4459.14.camel@jlt3.sipsolutions.net> (sfid-20120820_132430_471689_1CBC0B8F)
Subject: Re: [PATCH 1/2] mac80211: use skb_queue_walk() in
 mesh_path_assign_nexthop
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Aug 2012 13:24:24 +0200
In-Reply-To: <1344561132-31892-1-git-send-email-thomas@cozybit.com> (sfid-20120810_031222_496929_955E2F5E)
References: <1344561132-31892-1-git-send-email-thomas@cozybit.com>
	 (sfid-20120810_031222_496929_955E2F5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-08-09 at 18:12 -0700, Thomas Pedersen wrote:
> Since all we really want is just to iterate over all skbs, do just that
> and avoid (de)queueing to a clusmy tmpq.

Applied both, thanks.

johannes

