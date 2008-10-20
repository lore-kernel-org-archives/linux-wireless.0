Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:51375 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYJTFYn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 01:24:43 -0400
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: Power saving on mac80211
References: <43e72e890810171810t1c65642g998db601cfe2a390@mail.gmail.com>
	<87bpxh6t1n.fsf@nokia.com> <87y70l59p4.fsf@nokia.com>
	<1224412006.6324.45.camel@johannes.berg> <871vyc7st7.fsf@nokia.com>
	<1224434885.6324.49.camel@johannes.berg> <87myh0a1zd.fsf@nokia.com>
	<43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 20 Oct 2008 08:23:49 +0300
In-Reply-To: <43e72e890810191846h46a6b35br4ad61803a25bdf23@mail.gmail.com> (ext Luis R. Rodriguez's message of "Sun\, 19 Oct 2008 18\:46\:28 -0700")
Message-ID: <87tzb7j0uy.fsf@nokia.com> (sfid-20081020_072446_724616_D136BE20)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez <mcgrof@gmail.com> writes:

>>> Right. But we need to program the chip to tell the chip "hey please tell
>>> me if you haven't seen a beacon in X seconds".
>>
>> Ah, you mean that timeout. Sorry, I forgot that one altogether. Yes,
>> we definitely need that timeout.
>
> Is this to configure the firmware to report beacon misses so that in
> those cases we can inform mac80211?

Yes.

> And to let mac80211 be aware/be able to set this as a tunable
> parameter?

Yes.

> I wanted to note intel hardware seems to handle parsing beacons in
> firmware when is PS mode already and I have no clue when it would
> inform mac80211 of a beacon miss and if it does it. Tomas?

Oh, cool. I'm not familiar with iwlwifi so I would appreciate any
pointers to the sources so that I could take a look at the
implementation.

Sorry for the short answers, Monday morning...

-- 
Kalle Valo
