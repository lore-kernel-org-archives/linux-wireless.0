Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454Ab3HWJrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:47:06 -0400
Message-ID: <1377251223.14021.16.camel@jlt4.sipsolutions.net> (sfid-20130823_114710_808640_BC994934)
Subject: Re: [PATCH v2 01/16] wcn36xx: Add main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	wcn36xx@lists.infradead.org
Date: Fri, 23 Aug 2013 11:47:03 +0200
In-Reply-To: <CAFSJ42YsC2qO1iqocfOujZ5TUkKKAQMCiwLxjGZKZW7xy=J=pA@mail.gmail.com> (sfid-20130823_114258_969349_A8F7FE22)
References: <1377248299-21007-1-git-send-email-k.eugene.e@gmail.com>
	 <1377248299-21007-2-git-send-email-k.eugene.e@gmail.com>
	 <1377249774.14021.15.camel@jlt4.sipsolutions.net>
	 <CAFSJ42YsC2qO1iqocfOujZ5TUkKKAQMCiwLxjGZKZW7xy=J=pA@mail.gmail.com>
	 (sfid-20130823_114258_969349_A8F7FE22)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-08-23 at 11:42 +0200, Eugene Krasnikov wrote:
> >> +static const struct ieee80211_iface_limit if_limits[] = {
> >> +     { .max = 2, .types = BIT(NL80211_IFTYPE_STATION) },
> >> +     { .max = 1, .types = BIT(NL80211_IFTYPE_AP) },
> >> +};
> >> +
> >> +static const struct ieee80211_iface_combination if_comb = {
> >> +     .limits = if_limits,
> >> +     .n_limits = ARRAY_SIZE(if_limits),
> >> +     .max_interfaces = 2,
> >> +     .num_different_channels = 1,
> >> +};

> Exactly. So far wcn36xx supports only one interface.

But you're still advertising two.

johannes


