Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33095 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752601AbcDFHVV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2016 03:21:21 -0400
Message-ID: <1459927276.17504.6.camel@sipsolutions.net> (sfid-20160406_092123_787096_8281532F)
Subject: Re: [PATCHv2 1/2] mac80211: implement fair queuing per txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Apr 2016 09:21:16 +0200
In-Reply-To: <CAA93jw4Swv9aOr=ZKoKeQyp9f1HnYJtiY7a1Lw2Ri89XjGiORQ@mail.gmail.com> (sfid-20160405_163214_205637_31041D5D)
References: <1458898052-20601-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-1-git-send-email-michal.kazior@tieto.com>
	 <1459420104-31554-2-git-send-email-michal.kazior@tieto.com>
	 <1459864656.18188.60.camel@sipsolutions.net>
	 <CAA93jw4Swv9aOr=ZKoKeQyp9f1HnYJtiY7a1Lw2Ri89XjGiORQ@mail.gmail.com>
	 (sfid-20160405_163214_205637_31041D5D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[removing other lists since they spam me with moderation bounces]

> The hope had been the original codel.h would have been reusable,
> which is not the case at present.

So what's the strategy for making it happen? Unless there is one, I
don't see the point in making the code more complicated than it already
has to be anyway.

johannes
