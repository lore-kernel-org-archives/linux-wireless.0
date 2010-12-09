Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50429 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0LINxw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 08:53:52 -0500
Subject: Re: [PATCH] cfg80211: update information elements in cached BSS
 struct
From: Johannes Berg <johannes@sipsolutions.net>
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1291900640.1924.33.camel@sven>
References: <1291891690-26118-1-git-send-email-s.neumann@raumfeld.com>
	 <1291898876.3540.4.camel@jlt3.sipsolutions.net>
	 <1291900640.1924.33.camel@sven>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 14:53:50 +0100
Message-ID: <1291902830.3540.8.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 14:17 +0100, Sven Neumann wrote:
[snip

> Please review this patch again. I am pretty sure that there's something
> broken. Perhaps my fix is not totally correct, but it fixes a
> reproducable association problem for us.

You're right, the if catches that.

Can you please make the variable a bool, remove the blank line before
it? And your line length was way above 80. A comment would also be good
about why this is done, maybe a one-liner like the probe resp one, just
saying "Override IEs if they were from a beacon before".

Thanks!

johannes

