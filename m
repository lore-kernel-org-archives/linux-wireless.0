Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:49044 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3JUMvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 08:51:55 -0400
Received: by mail-la0-f52.google.com with SMTP id eh20so475182lab.25
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 05:51:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87wql7tac9.fsf@purkki.adurom.net>
References: <CAA2SeNJRSPB=Hus8y1bYJ-O1Hgkd=gvNhUKnF9atqwuhd2m0aA@mail.gmail.com>
 <CAB=NE6WSNZ10pNfKN5-o0cnVYkZbt4gGAzPOcO=Dtw5aUj+wGA@mail.gmail.com> <87wql7tac9.fsf@purkki.adurom.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Mon, 21 Oct 2013 14:51:32 +0200
Message-ID: <CAB=NE6U94K_KvhcPUvPL+S25Nw5J1Y300ASADa7C6-J_pBEW3A@mail.gmail.com> (sfid-20131021_145158_564657_17DA4DAE)
Subject: Re: Active scanning on DFS channels
To: Kalle Valo <kvalo@adurom.com>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 21, 2013 at 8:19 AM, Kalle Valo <kvalo@adurom.com> wrote:
> "Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
>
>>> Should we perform
>>> passive scan on radar channel setting new state to SCAN_DECISION and
>>> not to SCAN_SEND_PROBE in ieee80211_scan_state_set_channel()?
>>
>> There's a few thing we need to do and I'm working on it.
>>
>>   1) no-ibss and passive-scan flags should be merged to a no-ir flag
>
> For me IR always reminds of infrared, so the name no-ir is a bit vague
> to me :)

Any recommendations? I'm just lazy.

 Luis
