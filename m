Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:38031 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab3GZIHD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jul 2013 04:07:03 -0400
Received: by mail-lb0-f178.google.com with SMTP id y6so2252884lbh.37
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jul 2013 01:07:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1374825552.8248.2.camel@jlt4.sipsolutions.net>
References: <CAB=NE6V_PKG2UBSLPRhziUDcFzFi8uOJNiNzoPNaK0oU7rmZuQ@mail.gmail.com>
 <1374825552.8248.2.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 26 Jul 2013 01:06:40 -0700
Message-ID: <CAB=NE6Wr1hC2mQy1qo79yAawkw1cVsTG4unEFYYdu7vWKMM2MA@mail.gmail.com> (sfid-20130726_100718_765795_C774440D)
Subject: Re: Updates to wireless-regdb review - vendor namespaces and VHT80
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 12:59 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2013-07-02 at 17:38 -0700, Luis R. Rodriguez wrote:
>
>> I'd like to propose a middle ground to also address another issue I've
>> noticed. Vendors can disagree and in order to give vendors a warm
>> fuzzy on ability to ensure their data is interpreted and provide the
>> ability to offload down to wireless-regdb even more interpretations
>> I'd like to propose the idea of embracing vendor namespaces within
>> wireless-regdb / crda / the kernel. The way I'd envision this is
>> '/sbin/crda US OUI' is passed upon a regulatory hint and in turn CRDA
>> will read the namespace for the OUI passed in regulatory.bin. Then at
>> our wireless summit kumbaya and with the development / enhancements of
>> intersect.c and union.c (not yet developed) we'd work on generalizing
>> the data. This would also allow vendors to supply their own rules
>> without the high bar that we are setting which so far has proven very
>> difficult to met.
>
> I'm not really fully convinced, but let's discuss at the summit.
>
> Wasn't the point of the regdb and documentation etc. also that the users
> can trust it? It seems to me that if you're building a generic system
> you wouldn't really want different regulatory interpretations. And if
> you think for some special system (say a tablet) you need a different
> database, you'll probably hand-roll one specifically for that system
> anyway.

I don't think that's the problem. The problem is more -- folks are not
used to and don't wan to engage. What do we do in the meantime where
the alternative is something separate and likely redistributable
elsewhere. I'd personally rather have folks engaged and I figured a
namespace would at least provide a central middle ground. Glad to
discuss at the summit.

  Luis
