Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35269 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab1LGJ7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 04:59:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ-VmomuA7u5=zRGMK2Jd3WG+HWTRTZNST4JDVWU9kUEcfE91Q@mail.gmail.com>
References: <CAA93jw7kQYONQiAozatRmdRRJeK0GB9eNDWtRZ3AL+OVKn0OpA@mail.gmail.com>
	<1323082774.2670.40.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<CAJ-VmomuA7u5=zRGMK2Jd3WG+HWTRTZNST4JDVWU9kUEcfE91Q@mail.gmail.com>
Date: Wed, 7 Dec 2011 10:59:45 +0100
Message-ID: <CAA93jw6w1KAUwW0_TTwCuAScMnq1+RUQzLGZsRqPy_txPGbcjw@mail.gmail.com> (sfid-20111207_105955_437326_F9146500)
Subject: Re: Time in Queue, bufferbloat, and... our accidentally
 interplanetary network
From: Dave Taht <dave.taht@gmail.com>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	bloat <bloat@lists.bufferbloat.net>,
	bloat-devel <bloat-devel@lists.bufferbloat.net>,
	netdev@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 6, 2011 at 3:03 AM, Adrian Chadd <adrian@freebsd.org> wrote:
> Hi,
>
> For what it's worth, I've also been tinkering with time-in-queue for
> the wifi queue management in FreeBSD. I don't have anything public
> yet. What I have done actually seems to work quite well, when doing TX
> queue time-in-queue management. (I'm ignoring RX queue management for
> now.)
>
> Yes, I think a weighted random drop with both time-in-queue and queue
> depth would work well. I haven't sat down to model what it'd look like
> given some traffic profiles.
>
> I'll be sure to post some patches and results when I have them. :)

Well, if there is a way to add BQL sanely to the mac80211 or driver
layers and then apply some time in queue techniques at some edge
of some layer(s) down there in Linux, I'd love to know what and where
is good.

It might be simpler to discuss design ideas etc, in a more generic
and less noisy forum than netdev and linux-wireless, at least
for a while, getting to actual patches seems kind of hard at this point.

(at least to me. For all I know eric is finished already, and me, I haven't
 finished grokking the paper he's leveraging some ideas on)

The little I understand about Linux's networking stack dwarfs the
little I know about BSD's, so I look forward to hearing about your
results as you get them, and that said, if you could provide some
pointers and insight into BSD's traffic shaping methods over on
bloat-devel, we do try to be all-architecture embracing in our
attempts to beat the bloat.

>
>
> Adrian



-- 
Dave Täht
SKYPE: davetaht
US Tel: 1-239-829-5608
FR Tel: 0638645374
http://www.bufferbloat.net
