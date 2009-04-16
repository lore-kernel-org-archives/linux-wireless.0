Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:64294 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZDPGAt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 02:00:49 -0400
Received: by fxm2 with SMTP id 2so223201fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 23:00:48 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: avoid crashing when no scan sdata
References: <1239823995.20927.3.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 09:00:46 +0300
In-Reply-To: <1239823995.20927.3.camel@johannes.local> (Johannes Berg's message of "Wed\, 15 Apr 2009 21\:33\:15 +0200")
Message-ID: <87skk9f88h.fsf@litku.valot.fi> (sfid-20090416_080052_485108_63492D81)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Using the scan_sdata variable here is terribly wrong,
> if there has never been a scan then we fail. However,
> we need a bandaid...
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> Cc: stable@kernel.org [2.6.29]
> ---
> John, for 2.6.29 and 2.6.30 we need this bandaid -- my new work to
> properly fix this can only go into 2.6.31.

Sorry, I did this mistake. Thanks for fixing it!

-- 
Kalle Valo
