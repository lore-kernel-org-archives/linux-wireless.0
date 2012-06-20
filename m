Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab2FTItF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 04:49:05 -0400
Message-ID: <1340182143.4655.43.camel@jlt3.sipsolutions.net> (sfid-20120620_104909_220907_42616B8D)
Subject: Re: [PATCH v2 7/7] mac80211: add DFS support to monitor interface
From: Johannes Berg <johannes@sipsolutions.net>
To: Victor Goldenshtein <victorg@ti.com>
Cc: linux-wireless@vger.kernel.org, kgiori@qca.qualcomm.com,
	mcgrof@frijolero.org, zefir.kurtisi@neratec.com,
	adrian.chadd@gmail.com, j@w1.fi, coelho@ti.com, assaf@ti.com,
	yoni.divinsky@ti.com, igalc@ti.com, adrian@freebsd.org,
	nbd@nbd.name, simon.wunderlich@s2003.tu-chemnitz.de
Date: Wed, 20 Jun 2012 10:49:03 +0200
In-Reply-To: <1340111463-4554-7-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
	 <1340111463-4554-7-git-send-email-victorg@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-19 at 16:11 +0300, Victor Goldenshtein wrote:

> +	bool dfs_supported = !!(local->hw.wiphy->features &
> +				NL80211_FEATURE_DFS);

No need for !!, also why not inline that into the condition?

johannes

