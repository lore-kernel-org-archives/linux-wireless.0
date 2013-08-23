Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ve0-f169.google.com ([209.85.128.169]:45900 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab3HWKGG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 06:06:06 -0400
Received: by mail-ve0-f169.google.com with SMTP id db10so308319veb.28
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 03:06:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1377251223.14021.16.camel@jlt4.sipsolutions.net>
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	<1377248299-21007-2-git-send-email-k.eugene.e@gmail.com>
	<1377249774.14021.15.camel@jlt4.sipsolutions.net>
	<CAFSJ42YsC2qO1iqocfOujZ5TUkKKAQMCiwLxjGZKZW7xy=J=pA@mail.gmail.com>
	<1377251223.14021.16.camel@jlt4.sipsolutions.net>
Date: Fri, 23 Aug 2013 12:06:05 +0200
Message-ID: <CAFSJ42Zc8ZwO3VUSkEhg7sQGJzTrpgBez4g6BrV-fn4DowapCA@mail.gmail.com> (sfid-20130823_120618_471891_3C37768D)
Subject: Re: [PATCH v2 01/16] wcn36xx: Add main.c
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My bad. Did not clean up it completely.  if_comb is a dead code and is
not used anywhere. Will fix it.

2013/8/23 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2013-08-23 at 11:42 +0200, Eugene Krasnikov wrote:
>> >> +static const struct ieee80211_iface_limit if_limits[] = {
>> >> +     { .max = 2, .types = BIT(NL80211_IFTYPE_STATION) },
>> >> +     { .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
>> >> +};
>> >> +
>> >> +static const struct ieee80211_iface_combination if_comb = {
>> >> +     .limits = if_limits,
>> >> +     .n_limits = ARRAY_SIZE(if_limits),
>> >> +     .max_interfaces = 2,
>> >> +     .num_different_channels = 1,
>> >> +};
>
>> Exactly. So far wcn36xx supports only one interface.
>
> But you're still advertising two.
>
> johannes
>
>



-- 
Best regards,
Eugene
