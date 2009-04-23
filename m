Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:42179 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890AbZDWH51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 03:57:27 -0400
Received: by bwz7 with SMTP id 7so387588bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 23 Apr 2009 00:57:25 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix PS vs. scan race
References: <1240434171.30082.21.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 23 Apr 2009 10:57:23 +0300
In-Reply-To: <1240434171.30082.21.camel@johannes.local> (Johannes Berg's message of "Wed\, 22 Apr 2009 23\:02\:51 +0200")
Message-ID: <87zle7by58.fsf@litku.valot.fi> (sfid-20090423_095744_593550_52E794A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> When somebody changes the PS parameters while scanning
> is in progress, we enable PS -- during the scan. This
> is clearly not desirable, and we can just abort enabling
> PS when scanning since when the scan finishes it will
> be taken care of.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Reviewed-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
