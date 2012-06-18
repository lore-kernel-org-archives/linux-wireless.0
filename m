Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50777 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2FRHbJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jun 2012 03:31:09 -0400
Message-ID: <1340004660.4615.0.camel@jlt3.sipsolutions.net> (sfid-20120618_093114_028393_883DD706)
Subject: Re: [PATCH] iwlwifi: fix Oops on reading debugfs log_event
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Lekensteyn <lekensteyn@gmail.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 18 Jun 2012 09:31:00 +0200
In-Reply-To: <1339970748.7577.1.camel@joe2Laptop> (sfid-20120618_000553_585406_B71A06D4)
References: <7841457.8s9HYuaGXa@penguin>
	 <1339970748.7577.1.camel@joe2Laptop> (sfid-20120618_000553_585406_B71A06D4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-17 at 15:05 -0700, Joe Perches wrote:
> On Sun, 2012-06-17 at 22:58 +0200, Lekensteyn wrote:
> > Before this patch, reading log_event would print the event log to syslog and
> > crash if CONFIG_IWLWIFI_DEBUG was disabled (while CONFIG_IWLWIFI_DEBUGFS was
> > enabled of course).

I'll look at the patch, thanks.

> Make CONFIG_IWLWIFI_DEBUGFS dependent on CONFIG_IWLWIFI_DEBUG?

It's intentionally not dependent on each other today.

johannes

