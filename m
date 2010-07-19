Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966638Ab0GSU1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jul 2010 16:27:18 -0400
Subject: Re: [PATCH] cfg80211: fix WEXT ioctl GIWFREQ for monitor interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4C449C67.6010004@davizone.at>
References: <4C449C67.6010004@davizone.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Jul 2010 22:27:15 +0200
Message-ID: <1279571235.30478.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-07-19 at 20:41 +0200, David Gnedt wrote:
> The cfg80211_set_freq function now also saves the channel for monitor
> interfaces.
> This fixes a issue were the WEXT ioctl GIWFREQ doesn't report the correct
> channel when the channel was switched in monitor mode.

This is still wrong, as discussed previously on this list.

johannes

