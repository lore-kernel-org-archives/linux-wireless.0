Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:55797 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab0EZSWm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:22:42 -0400
Received: by pvg3 with SMTP id 3so1246255pvg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:22:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4825B8A2C4E264489E57869F0DCFB22343E33E6133@hasmsx502.ger.corp.intel.com>
References: <1274856569-13436-1-git-send-email-emmanuel.grumbach@intel.com>
	<AANLkTikzEywcDi9zyJknMWkKymCVYnWQa2YXbbSDVx5o@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22343E33E611F@hasmsx502.ger.corp.intel.com>
	<AANLkTinG2zWHE8l-ZPBnyrFq5gs4nZX59zhF3AVh7h_4@mail.gmail.com>
	<4825B8A2C4E264489E57869F0DCFB22343E33E6133@hasmsx502.ger.corp.intel.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 26 May 2010 11:22:21 -0700
Message-ID: <AANLkTilHP9QwNPWVgJhVxYxQF8hzM9cd6-eVKOJc9qC3@mail.gmail.com>
Subject: Re: [RFC] wireless-regdb: Add A band in IL
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 26, 2010 at 10:51 AM, Grumbach, Emmanuel
<emmanuel.grumbach@intel.com> wrote:
>>On Wed, May 26, 2010 at 10:32 AM, Grumbach, Emmanuel
>><emmanuel.grumbach@intel.com> wrote:
>>>>>  country IL:
>>>>>        (2402 - 2482 @ 40), (N/A, 20)
>>>>> +       (5150 - 5250 @ 40). (N/A, 200 mW), NO-OUTDOOR
>>>>> +       (5250 - 5350 @ 40). (N/A, 200 mW), NO-OUTDOOR, DFS
>>>>
>>>>I believe the one standing issue here is you are enabling HT40 on 5
>>>>GHz, how about enabling 2.4 GHz first, and then through a separate
>>>>patch and time/review we review the HT40 stuff, unless you are in no
>>>>rush to get 2.4 GHz enabled.
>>>>
>>>
>>> I am not following... HT40 on 2.4 GHz is already enabled...
>>> What should I enable in 2.4 GHz ?
>>
>>Sorry I meant 5 GHz.
>
> Actually 40GHz is less a problem in 5GHz than in 2.4GHz since in 2.4GHz
> I need to have a "Coexistence mechanism", which is not required in 5GHz.
> This Coexistence mechanism is apparently implemented by one OEM under the
> name "Clear Channel Assessment (CCA)".
>
> In short, I don't think there is any special issue with 40MHz in 5GHz, but
> I may miss something here... In any case, I have no problem with sending
> a patch that allows 5GHz in 20MHz for the moment.
> I can also have a look at the EEPROM in our NICs which is supposed to have
> all the needed limitations. Details to follow tomorrow.

OK thanks for the clarification Emmanuel, please give Michael some
time to review.

  Luis
