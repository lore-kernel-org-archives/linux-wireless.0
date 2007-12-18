Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:25537 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbXLRNlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Dec 2007 08:41:06 -0500
Received: by fk-out-0910.google.com with SMTP id z23so2062961fkz.5
        for <linux-wireless@vger.kernel.org>; Tue, 18 Dec 2007 05:41:05 -0800 (PST)
Message-ID: <c85cb4470712180541t1c469c88y9574ece5d4e4573@mail.gmail.com> (sfid-20071218_134111_130406_092829F2)
Date: Tue, 18 Dec 2007 15:41:04 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/8] mac80211: A-MPDU Rx add low level driver API
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <1197914053.4885.62.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <1197907078132-git-send-email-ron.rindjunsky@intel.com>
	 <1197914053.4885.62.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > +enum ieee80211_ampdu_mlme_flags {
> > +     IEEE80211_AMPDU_RX_START = 1<<0,
> > +     IEEE80211_AMPDU_RX_STOP  = 1<<1,
> > +};
>
> Can both really happen at the same time? Or why are they flags rather
> than just an action code?
>
i agree, it is confusing. i will change this enum to what you suggested.

thanks for typos and comments catches, i will fix them.

>
> @ssn will highlight the variable name afaik. I need to get my docbook
> stuff up to be mergeable.
>

didn't get this one. i didn't do @ssn as no other comment in
ieee80211_ops does it, it was just my extra info for drivers writers.
