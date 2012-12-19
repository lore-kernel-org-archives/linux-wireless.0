Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab2LSMJD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2012 07:09:03 -0500
Message-ID: <1355918963.9954.8.camel@jlt4.sipsolutions.net> (sfid-20121219_130907_568117_8C757F04)
Subject: Re: [PATCH] mac80211: RMC buckets are just list heads
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org
Date: Wed, 19 Dec 2012 13:09:23 +0100
In-Reply-To: <1355798517-27063-1-git-send-email-thomas@cozybit.com> (sfid-20121218_034223_498306_7A933775)
References: <1355798517-27063-1-git-send-email-thomas@cozybit.com>
	 (sfid-20121218_034223_498306_7A933775)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-12-17 at 18:41 -0800, Thomas Pedersen wrote:
> The array of rmc_entrys is redundant since only the
> list_head is used. Make this an array of list_heads
> instead and save ~6k per vif at runtime :D

:)
Applied.

johannes

