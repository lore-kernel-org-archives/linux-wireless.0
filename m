Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:35825 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZHQOVE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 10:21:04 -0400
Received: by fg-out-1718.google.com with SMTP id e21so673144fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 07:21:04 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove deprecated API
References: <1250518687.15103.9.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 17 Aug 2009 17:21:02 +0300
In-Reply-To: <1250518687.15103.9.camel@johannes.local> (Johannes Berg's message of "Mon\, 17 Aug 2009 16\:18\:07 +0200")
Message-ID: <874os6v7w1.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> All but two drivers have now stopped using the two
> deprecated members radio_enabled and beacon_int,
> so it's about time to remove them for good.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/at76c50x-usb.c |    5 ++---

For the at76 part:

Acked-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
