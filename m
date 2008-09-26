Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:45842 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbYIZUZN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 16:25:13 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1198768rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 13:25:10 -0700 (PDT)
Message-ID: <2da21fe50809261325o62dea98dyf40b06e373f29f53@mail.gmail.com> (sfid-20080926_222518_815757_A63F1AF6)
Date: Fri, 26 Sep 2008 22:25:09 +0200
From: "Davide Pesavento" <davidepesa@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: wireless-testing modpost failure
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, YanBo <dreamfly281@gmail.com>
In-Reply-To: <1222457416.3798.25.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2da21fe50809261104m3b7d99e3g8b56416b8182ca45@mail.gmail.com>
	 <20080926190007.GD3483@tuxdriver.com>
	 <1222457416.3798.25.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/9/26 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2008-09-26 at 15:00 -0400, John W. Linville wrote:
>
>> >   Building modules, stage 2.
>> >   MODPOST 216 modules
>> > ERROR: "mpp_path_lookup" [net/mac80211/mac80211.ko] undefined!
>> > ERROR: "mpp_path_add" [net/mac80211/mac80211.ko] undefined!
>
> Davide, can you tell me what file/line it fails in?
>

How can I tell you that?

>> I'm not sure what the best long-term solution is.  Should we define
>> empty versions of those functions when that config option is unset?
>> Or just make the whole block subject to that config option?
>
> The weird thing is that the block in tx.c is already ifdef'ed out and
> the block in rx.c should be optimised out entirely.
>
> johannes
>

Thanks,
Davide
