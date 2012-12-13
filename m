Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:41195 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab2LMWop (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 17:44:45 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so2265846lag.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 14:44:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1355337296-5815-2-git-send-email-johannes@sipsolutions.net>
References: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net> <1355337296-5815-2-git-send-email-johannes@sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 13 Dec 2012 14:44:23 -0800
Message-ID: <CAB=NE6Wudb52Wurot4j_+9JSjrcKHrfwgKmr_PVVftjLtfxY5A@mail.gmail.com> (sfid-20121213_234448_640067_85C62CFD)
Subject: Re: [PATCH 1/2] cfg80211: allow drivers to selectively disable 80/160 MHz
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 12, 2012 at 10:34 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Some drivers might support 80 or 160 MHz only on some
> channels for whatever reason, so allow them to disable
> these channel widths. Also maintain the new flags when
> regulatory bandwidth limitations would disable these
> wide channels.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

We need something to spell out VHT80 and VHT160 as a capability for
debugging on ht_print_chan(). This patch also seems to depend on a
patch posted as RFC, not PATCH. Apart from that:

Reviewed-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>

  Luis
