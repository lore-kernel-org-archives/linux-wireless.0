Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56187 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2LUOg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2012 09:36:58 -0500
Message-ID: <1356100638.9580.12.camel@jlt4.sipsolutions.net> (sfid-20121221_153701_660489_996EB747)
Subject: Re: [PATCH v2 3/3] mac80211_hwsim: emulate proper beaconing
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linville@tuxdriver.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com, j@wl.fi
Date: Fri, 21 Dec 2012 15:37:18 +0100
In-Reply-To: <1356029871-17794-3-git-send-email-thomas@cozybit.com> (sfid-20121220_195829_246974_F8E94B71)
References: <1356029871-17794-1-git-send-email-thomas@cozybit.com>
	 <1356029871-17794-3-git-send-email-thomas@cozybit.com>
	 (sfid-20121220_195829_246974_F8E94B71)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-20 at 10:57 -0800, Thomas Pedersen wrote:

> +	u64 now = __mac80211_hwsim_get_tsf(data);

That looks like an endian bug.

johannes

