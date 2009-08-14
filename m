Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:56839 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbZHNRPH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2009 13:15:07 -0400
Received: by bwz22 with SMTP id 22so1261341bwz.18
        for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2009 10:15:07 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] cfg80211: allow driver to override PS default
References: <1250112800.12285.0.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 14 Aug 2009 20:15:04 +0300
In-Reply-To: <1250112800.12285.0.camel@johannes.local> (Johannes Berg's message of "Wed\, 12 Aug 2009 23\:33\:20 +0200")
Message-ID: <87ab221fmv.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Sometimes drivers might have a good reason to override
> the PS default, like iwlwifi right now where it affects
> RX performance significantly at this point. This will
> allow them to override the default, if desired, in a
> way that users can still change it according to their
> trade-off choices, not the driver's, like would happen
> if the driver just disabled PS completely then.

This is a good idea. Thank you for finding a solution.

-- 
Kalle Valo
