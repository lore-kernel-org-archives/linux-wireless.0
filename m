Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:58353 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZERPns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:43:48 -0400
Received: by fxm2 with SMTP id 2so3320692fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 08:43:48 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: split out and decrease probe wait time
References: <1242151393.11924.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 18:43:46 +0300
In-Reply-To: <1242151393.11924.3.camel@johannes.local> (Johannes Berg's message of "Tue\, 12 May 2009 20\:03\:13 +0200")
Message-ID: <87pre6beml.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The time we wait for a probe response after probing an AP due to
> beacon loss is currently the same as the monitoring interval, 2s.
> This is far too long, APs should respond to probes within a
> fraction of that time. To be able to adjust both values, add a
> new constant IEEE80211_PROBE_WAIT, use it for checking the probe
> response, and adjust it down to 200ms instead of 2 seconds.

Looks good to me.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
