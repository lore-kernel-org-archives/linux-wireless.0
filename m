Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55327 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1ISNS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 09:18:27 -0400
Received: by fxe4 with SMTP id 4so3890519fxe.19
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 06:18:26 -0700 (PDT)
From: Alexander Simon <an.alexsimon@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 1/3] nl80211: Parse channel type attribute in an ibss join request
Date: Mon, 19 Sep 2011 15:18:22 +0200
Message-ID: <4703394.vfFCDJXmvM@alex-1> (sfid-20110919_151830_639857_1D549677)
In-Reply-To: <1316436761.5995.22.camel@jlt3.sipsolutions.net>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com> <1316436761.5995.22.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> With just this patch, you can set HT IBSS but mac80211 won't be able to
> do it so there probably should be some form of feature check for this so
> other (non-mac80211) drivers would be able to do this correctly -- I
> don't expect all of them to implement HT IBSS.
Just that i got this right: Mac80211 and other cfg80211-drivers should set 
some flag that HT IBSS is supported that we can check.
So that if HT IBSS is requested but not available we can return an error?
