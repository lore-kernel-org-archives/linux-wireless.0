Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:62671 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbYJTGeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:34:22 -0400
Received: by yx-out-2324.google.com with SMTP id 8so261275yxm.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Oct 2008 23:34:21 -0700 (PDT)
Message-ID: <43e72e890810192334v24c58998p36325723a6fa156a@mail.gmail.com> (sfid-20081020_083425_741424_E15C8981)
Date: Sun, 19 Oct 2008 23:34:21 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: Power saving on mac80211
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>
In-Reply-To: <87tzb7j0uy.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	 <87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	 <1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	 <1224434885.6324.49.camel@johannes.berg> <87myh0a1zd.fsf@nokia.com>
	 <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com>
	 <87tzb7j0uy.fsf@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 19, 2008 at 10:23 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
> Luis R. Rodriguez <mcgrof@gmail.com> writes:
>
>>>> Right. But we need to program the chip to tell the chip "hey please tell
>>>> me if you haven't seen a beacon in X seconds".
>>>
>>> Ah, you mean that timeout. Sorry, I forgot that one altogether. Yes,
>>> we definitely need that timeout.
>>
>> Is this to configure the firmware to report beacon misses so that in
>> those cases we can inform mac80211?
>
> Yes.
>
>> And to let mac80211 be aware/be able to set this as a tunable
>> parameter?
>
> Yes.
>
>> I wanted to note intel hardware seems to handle parsing beacons in
>> firmware when is PS mode already and I have no clue when it would
>> inform mac80211 of a beacon miss and if it does it. Tomas?
>
> Oh, cool. I'm not familiar with iwlwifi so I would appreciate any
> pointers to the sources so that I could take a look at the
> implementation.

Its all implemented in firmware.

  Luis
