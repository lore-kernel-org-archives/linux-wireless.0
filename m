Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44491 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299Ab1AaSoX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:44:23 -0500
Subject: Re: [PATCH] mac80211:  Recalculate channel-type on iface removal.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1296499072-6721-1-git-send-email-greearb@candelatech.com>
References: <1296499072-6721-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 31 Jan 2011 19:44:22 +0100
Message-ID: <1296499462.3812.41.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-01-31 at 10:37 -0800, greearb@candelatech.com wrote:

> Also, use WARN_ON_ONCE instead of WARN_ON if user has
> ht40- stations in conjunction with ht40+.  It's not
> really a kernel bug, just a mis-configuration of the
> user's wifi environment.

But how did we end up here to start with -- shouldn't that have been
rejected?

johannes

