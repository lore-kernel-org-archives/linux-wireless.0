Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:47887 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750766AbdESJiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 May 2017 05:38:52 -0400
From: =?utf-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: Dynamically set CoDel parameters per station
References: <20170405161810.30671-1-toke@toke.dk>
        <20170406093826.16626-1-toke@toke.dk>
        <1495029987.2442.19.camel@sipsolutions.net>
Date: Fri, 19 May 2017 11:27:38 +0200
In-Reply-To: <1495029987.2442.19.camel@sipsolutions.net> (Johannes Berg's
        message of "Wed, 17 May 2017 16:06:27 +0200")
Message-ID: <87efvldwmt.fsf@alrua-kau> (sfid-20170519_113856_258643_E31A41E1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2017-04-06 at 11:38 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> CoDel can be too aggressive if a station sends at a very low rate,
>> leading reduced throughput. This gets worse the more stations are
>> present, as each station gets more bursty the longer the round-robin
>> scheduling between stations takes.
>>=20
> [...]
>
> I've applied this now (with some minor fixups) - the whole discussion
> didn't really conclude in anything, and we can just try it.

Okidoki. FWIW, the reason I never got any further was that my
experiments with other approaches proved somewhat inconclusive. Partly
because a reorganisation of my testbed has caused the physical
conditions to change which has caused the original problem to be less
severe.

So yeah, some wider testing would be good, and I agree that it is low
risk. I'll revisit this myself at some point after I get my testbed
rebased on a new kernel and figure out why the physical conditions
changed... :)

-Toke
