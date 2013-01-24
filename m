Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55151 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920Ab3AXPEj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:04:39 -0500
Message-ID: <1359039903.21908.3.camel@jlt4.sipsolutions.net> (sfid-20130124_160443_007667_114E984F)
Subject: Re: [PATCH 2/2] mac80211: support mesh rate updates
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: javier@cozybit.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org
Date: Thu, 24 Jan 2013 16:05:03 +0100
In-Reply-To: <1358972293-2884-2-git-send-email-thomas@cozybit.com> (sfid-20130123_211904_054764_808A46E7)
References: <1358972293-2884-1-git-send-email-thomas@cozybit.com>
	 <1358972293-2884-2-git-send-email-thomas@cozybit.com>
	 (sfid-20130123_211904_054764_808A46E7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 12:18 -0800, Thomas Pedersen wrote:
> An existing mesh station entry may change its rate
> capabilities, so call rate_control_rate_update() to notify
> the rate control.

Applied, with a fix to make it compile. Tssk Tssk.

johannes

