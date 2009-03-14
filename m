Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:65154 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZCNGYp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 02:24:45 -0400
Received: by fxm24 with SMTP id 24so2872693fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 23:24:42 -0700 (PDT)
To: Samuel Ortiz <samuel@sortiz.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Alina Friedrichsen <x-alina@gmx.net>,
	linux-wireless@vger.kernel.org, j@w1.fi
Subject: Re: configuring while interface is down
References: <1236774973.20266.13.camel@johannes.local>
	<20090311134329.269810@gmx.net>
	<1236779314.20266.22.camel@johannes.local>
	<20090311145216.GB6986@sortiz.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 14 Mar 2009 08:24:39 +0200
In-Reply-To: <20090311145216.GB6986@sortiz.org> (Samuel Ortiz's message of "Wed\, 11 Mar 2009 15\:52\:16 +0100")
Message-ID: <87hc1w4o60.fsf@litku.valot.fi> (sfid-20090314_072756_913658_9BEC37D8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Samuel Ortiz <samuel@sortiz.org> writes:

>> which is what we'll continue doing in cfg80211, but I think we shouldn't
>> bother the driver/mac80211 with it until the netdev is up, and thus
>> reject things from nl80211.
>
> That is quite reasonable, please go for it.

I fully agree. It's good to enforce this in cfg80211.

-- 
Kalle Valo
