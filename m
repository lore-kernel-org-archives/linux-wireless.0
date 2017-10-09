Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lang.hm ([66.167.227.134]:38232 "EHLO bifrost.lang.hm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753948AbdJIHuo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Oct 2017 03:50:44 -0400
Date: Mon, 9 Oct 2017 00:50:20 -0700 (PDT)
From: David Lang <david@lang.hm>
To: Johannes Berg <johannes@sipsolutions.net>
cc: =?ISO-8859-15?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>,
        make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Subject: Re: [Make-wifi-fast] [RFC] mac80211: Add airtime fairness
 accounting
In-Reply-To: <1507533328.26041.12.camel@sipsolutions.net>
Message-ID: <alpine.DEB.2.02.1710090047220.7677@nftneq.ynat.uz> (sfid-20171009_095047_868007_3A5254DC)
References: <20171006115232.28688-1-toke@toke.dk> <1507298832.19300.20.camel@sipsolutions.net> <87lgkoqrhs.fsf@toke.dk> <1507310319.19300.28.camel@sipsolutions.net> <87infrqk28.fsf@toke.dk> <1507533328.26041.12.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-101407083-1507535421=:7677"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-101407083-1507535421=:7677
Content-Type: TEXT/PLAIN; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 9 Oct 2017, Johannes Berg wrote:

> On Sat, 2017-10-07 at 13:22 +0200, Toke Høiland-Jørgensen wrote:
>
>> Guess you are right that it will be difficult to get a completely
>> accurate number. But as David Lang notes, as long as we are off by
>> the same amount for all stations, that is fine - we're just
>> interested in relative numbers.
>
> That's not quite true though, you'd overestimate most on stations that
> are using aggregation, assuming you take into account the whole frame
> exchange sequence time. But maybe giving less than their fair share to
> fast stations isn't really that much of a problem.

how much error does this introduce?
Compared to the stations using 802.11b, this is a trivial difference.

That's why I said perfect is the enemy of good enough. Yes, it would be ideal to 
get the airtime from the driver, but if the driver doesn't provide it, I think 
ignoring aggregation in the name of simplicity is 'good enough'

David Lang
--680960-101407083-1507535421=:7677--
