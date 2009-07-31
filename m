Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:33285 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbZGaJ1O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 05:27:14 -0400
Received: by bwz19 with SMTP id 19so1082095bwz.37
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 02:27:14 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: lower dynamic PS timeout to 100ms
References: <1249031893.29587.63.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 31 Jul 2009 12:20:54 +0300
In-Reply-To: <1249031893.29587.63.camel@johannes.local> (Johannes Berg's message of "Fri\, 31 Jul 2009 11\:18\:13 +0200")
Message-ID: <87skgdnr7t.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The default of 500ms is pretty high, and leads
> to the device being awake at least 50% of the
> time under such light traffic conditions as a
> simple 1 second interval ping. Reduce to just
> 100ms -- it should have a similar effect while
> providing a better sleep time.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

I agree, 500 ms is too long.

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
