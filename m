Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab2K2Mjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:39:51 -0500
Message-ID: <1354192815.9557.7.camel@jlt4.sipsolutions.net> (sfid-20121129_133953_680179_90C60B91)
Subject: Re: [PATCH] mac80211: add debugfs file for current tx rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Saravana <saravanad@posedge.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 29 Nov 2012 13:40:15 +0100
In-Reply-To: <50B61054.3090604@posedge.com>
References: <50B61054.3090604@posedge.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 18:53 +0530, Saravana wrote:
> Add a debugfs file showing the current tx rate.
> The information available in the rc_stats file
> doesn't evidently provides us the current tx rate.
> This patch adds the support for the same.

This didn't apply, it conflicts with your other patch. I've therefore
also not applied the re-organise patch for now, but no need to resend
that one, just this one would be good.

johannes

