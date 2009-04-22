Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:47687 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbZDVNcn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 09:32:43 -0400
Received: by bwz7 with SMTP id 7so2346031bwz.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Apr 2009 06:32:41 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: remove IEEE80211_CONF_CHANGE_DYNPS_TIMEOUT
References: <1240396807.21978.4.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 22 Apr 2009 16:32:39 +0300
In-Reply-To: <1240396807.21978.4.camel@johannes.local> (Johannes Berg's message of "Wed\, 22 Apr 2009 12\:40\:07 +0200")
Message-ID: <87ws9ceruw.fsf@litku.valot.fi> (sfid-20090422_153255_990432_FDD78191)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Just setting IEEE80211_CONF_CHANGE_PS should be sufficient
> for changes in the power saving things. The driver already
> tells us whether it wants notification of dynps via the
> "have dynps support" hw flag.

I agree.

> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
