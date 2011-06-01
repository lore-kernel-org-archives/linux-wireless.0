Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746Ab1FAERE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 00:17:04 -0400
Subject: Re: [PATCH v7] mac80211_hwsim driver support userspace frame tx/rx
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Lopez <jlopex@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com, j@w1.fi,
	javier@cozybit.com
In-Reply-To: <1306879610-21242-1-git-send-email-jlopex@gmail.com> (sfid-20110601_000722_231691_6D77025C)
References: <BANLkTi=_snQBSFH-d344bjk8-aSeC9Jh5w@mail.gmail.com>
	 <1306879610-21242-1-git-send-email-jlopex@gmail.com>
	 (sfid-20110601_000722_231691_6D77025C)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 06:16:54 +0200
Message-ID: <1306901814.3867.1.camel@jlt3.sipsolutions.net> (sfid-20110601_061709_681761_3400344D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-01 at 00:06 +0200, Javier Lopez wrote:
> This patch adds to mac80211_hwsim the capability to send traffic via 
> userspace.

Looks good, thanks for your patience.

> +++ b/drivers/net/wireless/mac80211_hwsim.h

This file is for userspace, no?

> @@ -0,0 +1,131 @@
> +/*
> + * mac80211_hwsim - software simulator of 802.11 radio(s) for mac80211
> + * Copyright (c) 2008, Jouni Malinen <j@w1.fi>
> + * Copyright (c) 2011, Javier Lopez <jlopex@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <net/mac80211.h>

It shouldn't include that then, but it doesn't really matter anyway.

johannes

