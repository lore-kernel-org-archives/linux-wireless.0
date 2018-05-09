Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:55073 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964984AbeEIVgT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 17:36:19 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/3] net: Dynamically allocate struct station_info
In-Reply-To: <1525901625.6910.33.camel@sipsolutions.net>
References: <152586802501.18089.2502272945272741154.stgit@alrua-kau> <152586802515.18089.12700714478750075562.stgit@alrua-kau> <1525901625.6910.33.camel@sipsolutions.net>
Date: Wed, 09 May 2018 23:36:27 +0200
Message-ID: <87vabwy0is.fsf@toke.dk> (sfid-20180509_233623_305374_9793C7C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> WARN_ON is used where the function has no way to signal errors to the
>> caller.
>
> There isn't really much point in that - failing allocations are already
> *very* noisy. Please respin with that removed (and then I guess you can
> fix the Fixes: too)

OK, will do.

> You didn't actually do that in this patch though :-)

Well, I may have copy-pasted that from the commit message of the
previous patch ;)

> It's bool so you don't need the !!(...) :-)

But what if I want it to be extra super duper bool? ;)

-Toke
