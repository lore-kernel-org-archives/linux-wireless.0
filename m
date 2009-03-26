Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:43612 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457AbZCZIjR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 04:39:17 -0400
Received: by rv-out-0506.google.com with SMTP id f9so519705rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 01:39:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238055060.4331.1.camel@johannes.local>
References: <1237891149.4320.73.camel@johannes.local> <1237910398.9082.7.camel@localhost.localdomain>
	<1237979070.4320.156.camel@johannes.local> <1237995072.18896.9.camel@localhost.localdomain>
	<1237996137.4320.161.camel@johannes.local> <43e72e890903260100w75896d0fi9121f227cc7ca8dc@mail.gmail.com>
	<1238055060.4331.1.camel@johannes.local>
Date: Thu, 26 Mar 2009 01:39:00 -0700
Message-ID: <43e72e890903260139k29d9e9a0ub418cdfbaef03418@mail.gmail.com> (sfid-20090326_093922_116077_A3A24754)
Subject: Re: wireless powersaving (in NM?)
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Matthew Garrett <mjg@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 26, 2009 at 1:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-03-26 at 01:00 -0700, Luis R. Rodriguez wrote:
>
>> > Right. If a particular chipset doesn't properly supported PS then =
we
>> > shouldn't actually support it at all -- but we cannot know if the =
AP is
>> > broken.
>>
>> How about leaving it to the supplicant to guess if the AP is borked =
or not.
>>
>> Kalle, what would happen with these broken APs?
>
> We talked about that briefly yesterday -- it's not very easy to
> determine this because of the various ways things break:
>
> =C2=A0* one AP sets the broadcast/multicast bit one beacon too late (=
after
> =C2=A0 having already sent the frames)
> =C2=A0* one AP doesn't buffer frames at all
> =C2=A0* one AP doesn't respond to PS-poll frames

It sounds like all 3 things can be tested for.

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
