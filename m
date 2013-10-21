Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45989 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798Ab3JUO37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 10:29:59 -0400
From: Kalle Valo <kvalo@adurom.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: Active scanning on DFS channels
References: <CAA2SeNJRSPB=Hus8y1bYJ-O1Hgkd=gvNhUKnF9atqwuhd2m0aA@mail.gmail.com>
	<CAB=NE6WSNZ10pNfKN5-o0cnVYkZbt4gGAzPOcO=Dtw5aUj+wGA@mail.gmail.com>
	<87wql7tac9.fsf@purkki.adurom.net>
	<CAB=NE6U94K_KvhcPUvPL+S25Nw5J1Y300ASADa7C6-J_pBEW3A@mail.gmail.com>
Date: Mon, 21 Oct 2013 17:29:56 +0300
In-Reply-To: <CAB=NE6U94K_KvhcPUvPL+S25Nw5J1Y300ASADa7C6-J_pBEW3A@mail.gmail.com>
	(Luis R. Rodriguez's message of "Mon, 21 Oct 2013 14:51:32 +0200")
Message-ID: <87sivuu26z.fsf@purkki.adurom.net> (sfid-20131021_163002_729480_E4F8B909)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:

> On Mon, Oct 21, 2013 at 8:19 AM, Kalle Valo <kvalo@adurom.com> wrote:
>> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
>>
>>>> Should we perform
>>>> passive scan on radar channel setting new state to SCAN_DECISION and
>>>> not to SCAN_SEND_PROBE in ieee80211_scan_state_set_channel()?
>>>
>>> There's a few thing we need to do and I'm working on it.
>>>
>>>   1) no-ibss and passive-scan flags should be merged to a no-ir flag
>>
>> For me IR always reminds of infrared, so the name no-ir is a bit vague
>> to me :)
>
> Any recommendations? I'm just lazy.

no-sta-tx sounds dumb, but I can't think of anything better. Sorry.

-- 
Kalle Valo
