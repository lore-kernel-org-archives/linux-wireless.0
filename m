Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:38783 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751047AbeDSKab (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 06:30:31 -0400
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Johannes Berg <johannes@sipsolutions.net>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/3] Export TXQ parameters and statistics via nl80211
In-Reply-To: <1524131536.3024.16.camel@sipsolutions.net>
References: <20180219170224.14816-1-toke@toke.dk> <8736zr1rjh.fsf@toke.dk> <1524131536.3024.16.camel@sipsolutions.net>
Date: Thu, 19 Apr 2018 12:30:30 +0200
Message-ID: <87o9ifzdx5.fsf@toke.dk> (sfid-20180419_123035_350922_F7861FA5)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-04-19 at 11:20 +0200, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:
>>=20
>> > This series adds TXQ parameters and statistics that were previously on=
ly
>> > available through debugfs to the nl80211 userspace interface and the
>> > cfg80211 kernel interface. Patches for iw to print the statistics and
>> > change the settings are included.
>>=20
>> So this patch set is now three months old. Any chance of actually
>> getting it, you know, merged? Or is there something more I need to do? :)
>
> I was just thinking about it yesterday, "sighing" that I'll need to make
> a decision even though I don't really know it well and can't even say if
> another API would be better :-)

Right. Well, feel free to bikeshed the API if you want. I just went with
the straight-forward approach :)

> I think I'll take it, but I guess I'll need to review it again.

Cool.

-Toke
