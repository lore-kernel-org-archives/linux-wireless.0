Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:59716 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755538AbZHJQVG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 12:21:06 -0400
Received: by fxm28 with SMTP id 28so1016726fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 09:21:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: add missing device list locking
References: <1249811489.4636.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 10 Aug 2009 19:21:02 +0300
In-Reply-To: <1249811489.4636.2.camel@johannes.local> (Johannes Berg's message of "Sun\, 09 Aug 2009 11\:51\:29 +0200")
Message-ID: <873a7zljwx.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When calling into the wext code from the NETDEV_UP
> notifier, we need to hold the devlist_mtx mutex as
> the wext code ends up calling into channel checks.
>
> Reported-by: Kalle Valo <kalle.valo@iki.fi>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I have been testing with patch for a day now and no warnings anymore.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
