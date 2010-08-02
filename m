Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dev2day.de ([83.169.2.241]:56909 "EHLO dev2day.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310Ab0HBUsw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 16:48:52 -0400
Message-ID: <4C572F31.3050809@dev2day.de>
Date: Mon, 02 Aug 2010 22:48:49 +0200
From: Jan Friedrich <jft@dev2day.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] ath9k: fix erased ieee80211_rx_status.mactime
References: <4C57278E.1030601@dev2day.de> <20100802202137.GC8920@tux> <4C572C18.6070003@dev2day.de> <20100802203843.GD8920@tux>
In-Reply-To: <20100802203843.GD8920@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Think? Does the patch actually fix something or do you think it fixes
> something? Next time please include all these details on your patch
> commit log mesage so its easy to understand the reasoning behind
> the patch.

It fixes the problem I described. Now the mactime is set correctly and
the IBSS merge is done only once and by the correct station. I noticed
no negative side effect and tested it with 10+ stations in IBSS mode.

Sorry for the inconvenience. Next time I will provide more information.

Greetings,
Jan
