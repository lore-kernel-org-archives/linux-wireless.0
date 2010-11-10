Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab0KJQWt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 11:22:49 -0500
Subject: Re: [PATCH v7 1/3] cfg80211: Add nl80211 antenna configuration
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	mcgrof@gmail.com, linux-wireless@vger.kernel.org
In-Reply-To: <4CDAC16A.2050300@openwrt.org>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
	 <1289404367.3748.0.camel@jlt3.sipsolutions.net>
	 <4CDAC16A.2050300@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 08:24:06 -0800
Message-ID: <1289406246.3748.21.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-11-10 at 16:59 +0100, Felix Fietkau wrote:
> > I'm not entirely convinced that this is a good idea. Nor that, even if
> > 11n devices were to implement it, they should all implementing their own
> > code to update the HT capabilities. However, I suppose that nothing
> > forces them to implement it, and when somebody does I can still complain
> > when they put everything into the driver.

> Drivers already need to calculate their HT capabilities based on the
> number of chains.
> If chains get masked out based on the antenna mask settings, the driver
> code would most of the time only need minor refactoring for updating the
> settings which wouldn't necessarily result in any new code duplication
> at all.

Good point.

johannes

