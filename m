Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905AbZFQHVZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 03:21:25 -0400
Date: Wed, 17 Jun 2009 09:21:01 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Netdev <netdev@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	davem <davem@davemloft.net>
Subject: Re: [RFC] net: refactor multicast/unicast address list
Message-ID: <20090617072100.GA3492@psychotron.englab.brq.redhat.com>
References: <1244889678.13033.6.camel@johannes.local> <1244896094.13033.8.camel@johannes.local> <20090616111842.GG3521@psychotron.englab.brq.redhat.com> <1245151771.9256.3.camel@johannes.local> <20090616123808.GK3521@psychotron.englab.brq.redhat.com> <1245193788.21287.66.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1245193788.21287.66.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Jun 17, 2009 at 01:09:48AM CEST, johannes@sipsolutions.net wrote:
>On Tue, 2009-06-16 at 14:38 +0200, Jiri Pirko wrote:
>
>> >> Yes, I've already converted unicast lists to use list_head there. I'm sending
>> >> the patch doing the same for multicast lists soon.
>> >
>> >Very nice! After that maybe I'll take a look again at moving things into
>> >a common structure -- I ultimately want to use a multicast list without
>> >a netdev to sync multiple netdevs onto a common multicast list that is
>> >not part of a netdev.
>> 
>> I see, hmm, I think I can do this change with my conversion... I was thinking
>> about similar thing as you suggest before...
>
>I don't think the patch for converting the multicast lists will hit .31,
>I take it?

I'm preparing the patch right now. It's most likely it will hit .32.

>
>I'd like to get this patch into the .32 tree once it opens
>http://johannes.sipsolutions.net/patches/kernel/all/LATEST/NNN-net-core-mc-sync-list.patch
>
>but I don't know how to handle that wrt. your patch, which will clearly
>conflict with mein. Will you be sending that soon?

I see your need. I'll think about it and try to prepare the lists for this use.
>
>I guess we could stick this one into wireless-testing, and then take it
>out again once your patch hits the tree and offers me similar API for
>list_head based multicast lists?

Or wait, I hope the patch will be ready in week tops.

Jirka
>
>johannes


