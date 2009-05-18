Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:41721 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZERPCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 11:02:24 -0400
Received: by fxm2 with SMTP id 2so3294734fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 08:02:24 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: respond to beacon loss report only once
References: <1242151092.11924.2.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 18 May 2009 18:02:21 +0300
In-Reply-To: <1242151092.11924.2.camel@johannes.local> (Johannes Berg's message of "Tue\, 12 May 2009 19\:58\:12 +0200")
Message-ID: <87tz3ibgjm.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> The driver might keep reporting beacon loss until we
> disassociate -- catch that and don't respond to any
> subsequent events until the probe is either successful
> or we disassociate.

I agree.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
