Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:55720 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758123Ab3CZNYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Mar 2013 09:24:04 -0400
Received: by mail-ie0-f170.google.com with SMTP id c11so8848497ieb.1
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2013 06:24:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
 <CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
 <CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
 <201303251712.19808.chunkeey@googlemail.com> <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com>
 <CAMgrJ3afo=woPwXo6HO16b1CPuo4aRYM+w0__gQQYRvvJT3D-g@mail.gmail.com>
From: Robert Shade <robert.shade@gmail.com>
Date: Tue, 26 Mar 2013 09:23:43 -0400
Message-ID: <CAMgrJ3YdE+5M0rRdApJSTKLanc1LQ0KKRkS_PbYforvG3y1+9w@mail.gmail.com> (sfid-20130326_142409_899716_3D725E05)
Subject: Re: Auth Packet TX Delay
To: Adrian Chadd <adrian@freebsd.org>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k bug created: https://bugzilla.kernel.org/show_bug.cgi?id=55771

On Tue, Mar 26, 2013 at 8:21 AM, Robert Shade <robert.shade@gmail.com> wrote:
> I'll get a bug together, but I wanted to report that even with the
> patch above (fastcc disabled/cold reset always), it still eventually
> was unable to change the channel.  As soon as that failed, it's back
> into the state where it never seems to xmit anything in the data
> queues and can't associate.
>
> On Mon, Mar 25, 2013 at 12:45 PM, Adrian Chadd <adrian@freebsd.org> wrote:
>> One for each please.
>>
>>
>>
>>
>> Adrian
>>
>>
>> On 25 March 2013 09:12, Christian Lamparter <chunkeey@googlemail.com> wrote:
>>> On Monday, March 25, 2013 03:23:53 AM Adrian Chadd wrote:
>>>> Also, would you please make sure you file a bugzilla.kernel.org ticket
>>>> so this gets tracked?
>>>>
>>>> It's good to know that some combination of fast channel change and
>>>> warm versus cold reset is making things better/worse.
>>>>
>>>> And although a cold reset is likely a good thing to _fix_ the problem,
>>>> it still leaves the underlying DMA/PHY hangs unresolved.
>>>>
>>>> But yes, please file a bugzilla ticket so this gets tracked right!
>>> Um, do you want a bugreport for ath9k or carl9170 or for both?
>>>
>>> Regards,
>>>         Christian
