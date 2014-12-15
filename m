Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:59173 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750704AbaLOLzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 06:55:00 -0500
Message-ID: <1418644492.12873.27.camel@coelho.fi> (sfid-20141215_125504_593790_C4E97FE8)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kvalo@adurom.com,
	pizza@shaftnet.org, Johannes Berg <johannes.berg@intel.com>
Date: Mon, 15 Dec 2014 13:54:52 +0200
In-Reply-To: <1418643354-5597-1-git-send-email-johannes@sipsolutions.net>
References: <1418643354-5597-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: move U-APSD enablement to vif flags
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-15 at 12:35 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> In order to let drivers have more dynamic U-APSD support,
> move the enablement flag to the virtual interface driver
> flags. This lets drivers not only set it up differently
> for different interfaces, but also enable/disable on the
> fly if needed.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Looks fine to me.

For the wlcore and wl1251 parts:

Acked-by: Luciano Coelho <luca@coelho.fi>

--
Luca.

