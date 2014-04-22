Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42565 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932583AbaDVOoW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:44:22 -0400
Message-ID: <1398177842.4211.7.camel@jlt4.sipsolutions.net> (sfid-20140422_164432_162963_C9D5711A)
Subject: Re: [PATCH 02/12] mac80211: remove config option check
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:44:02 +0200
In-Reply-To: <3ed41ac7f29b74d7cfc81c42715cf2dc1706066c.1398055854.git.gamerh2o@gmail.com> (sfid-20140421_065456_045112_6B8FCF8F)
References: <cover.1398055853.git.gamerh2o@gmail.com>
	 <3ed41ac7f29b74d7cfc81c42715cf2dc1706066c.1398055854.git.gamerh2o@gmail.com>
	 (sfid-20140421_065456_045112_6B8FCF8F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-21 at 12:52 +0800, Zhao, Gang wrote:
> Sanity check and error handling code shouldn't be put into
> CONFIG_MAC80211_VERBOSE_DEBUG block, since verbose debug option is
> used to control whether to print debug messages.

It's in the hotpath though, so we don't always want it, it's mostly for
development that this matters.

I don't think I want to apply this patch.

johannes


