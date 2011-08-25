Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:45128 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1HYJ7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:59:54 -0400
Received: by mail-bw0-f47.google.com with SMTP id zu17so1691832bkb.6
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:59:53 -0700 (PDT)
Subject: Re: [PATCH 2/2] wl12xx: set mac80211 flags for aggregation support
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1314265865-20208-2-git-send-email-arik@wizery.com>
References: <1314265865-20208-1-git-send-email-arik@wizery.com>
	 <1314265865-20208-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 25 Aug 2011 12:59:38 +0300
Message-ID: <1314266378.2296.255.camel@cumari> (sfid-20110825_115959_380888_322DBAB2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-25 at 12:51 +0300, Arik Nemtsov wrote: 
> We set the flag for A-MPDU support and also indicate that Tx aggregation
> is performed in HW. This will prevent mac80211 from aggregating Tx
> packets in software.
> 
> This patch depends on
> "mac80211: add flag to indicate HW only Tx-agg support"

Please send patches with this kind of dependency separately.  One for
mac80211 (which John will apply) and one for wl12xx, which I will apply
once the dependency is solved.

This avoids confusion as to who should apply what.

-- 
Cheers,
Luca.

