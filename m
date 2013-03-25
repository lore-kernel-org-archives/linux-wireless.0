Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:63759 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758086Ab3CYQpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 12:45:49 -0400
Received: by mail-wg0-f50.google.com with SMTP id es5so2936781wgb.5
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2013 09:45:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201303251712.19808.chunkeey@googlemail.com>
References: <CAMgrJ3Y9=K4umoLD=htrrW-Wn4Hgi7qfaKDpY55_GKd=KgD==A@mail.gmail.com>
	<CAJ-VmonoNE1azzwZrjr+BX2un=oz9D_Tf3AAWdw9twJjyzFMOA@mail.gmail.com>
	<CAJ-Vmo=XMnm9b3t102q305Kj2LiVqEhTJ+X1+mrW=1X8cvArSg@mail.gmail.com>
	<201303251712.19808.chunkeey@googlemail.com>
Date: Mon, 25 Mar 2013 09:45:48 -0700
Message-ID: <CAJ-VmonVKm+SQrbB_D+0R-V5airK8fUZpE2Y_TK22TuMczMu6A@mail.gmail.com> (sfid-20130325_174553_703675_3F615186)
Subject: Re: Auth Packet TX Delay
From: Adrian Chadd <adrian@freebsd.org>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Robert Shade <robert.shade@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Marco Fonseca <marco@tampabay.rr.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One for each please.




Adrian


On 25 March 2013 09:12, Christian Lamparter <chunkeey@googlemail.com> wrote:
> On Monday, March 25, 2013 03:23:53 AM Adrian Chadd wrote:
>> Also, would you please make sure you file a bugzilla.kernel.org ticket
>> so this gets tracked?
>>
>> It's good to know that some combination of fast channel change and
>> warm versus cold reset is making things better/worse.
>>
>> And although a cold reset is likely a good thing to _fix_ the problem,
>> it still leaves the underlying DMA/PHY hangs unresolved.
>>
>> But yes, please file a bugzilla ticket so this gets tracked right!
> Um, do you want a bugreport for ath9k or carl9170 or for both?
>
> Regards,
>         Christian
