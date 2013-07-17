Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52191 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3GQEKT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jul 2013 00:10:19 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] beacon measurement (beacon filtering disable)
References: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
Date: Wed, 17 Jul 2013 07:10:18 +0300
In-Reply-To: <1373971517-315-1-git-send-email-johannes@sipsolutions.net>
	(Johannes Berg's message of "Tue, 16 Jul 2013 13:45:15 +0300")
Message-ID: <87oba1yggl.fsf@purkki.adurom.net> (sfid-20130717_061024_000970_C61F438C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> We have beacon filtering (to reduce host wakeups) in our device,
> but for some measurement/debug purposes we need to turn it off.

TBH I'm not really fond of this. I'm not really sure what's the use
case but first this sounded a like a factory test for me, not something
which a regular user would want to do.

Can't we connect this to power save? When disabling power save we could
also disable beacon filtering and would not need a separate command.

-- 
Kalle Valo
