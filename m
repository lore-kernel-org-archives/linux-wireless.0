Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:47014 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbYFYSGk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 14:06:40 -0400
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] mac80211: add phy information to giwname
References: <1214303881-31525-1-git-send-email-tomas.winkler@intel.com>
	<1214303881-31525-4-git-send-email-tomas.winkler@intel.com>
	<1214303881-31525-5-git-send-email-tomas.winkler@intel.com>
	<200806241242.11727.mb@bu3sch.de>
	<1ba2fa240806240354n45c144a3n5ac8b08c7da7b7a2@mail.gmail.com>
	<87vdzzdj5m.fsf@nokia.com>
	<1ba2fa240806240959q398c324al9d9c009c218c0489@mail.gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Wed, 25 Jun 2008 20:55:48 +0300
In-Reply-To: <1ba2fa240806240959q398c324al9d9c009c218c0489@mail.gmail.com> (Tomas Winkler's message of "Tue\, 24 Jun 2008 19\:59\:54 +0300")
Message-ID: <87vdzxmmaj.fsf@litku.valot.fi> (sfid-20080625_200643_312514_BA27AB8E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Tomas Winkler" <tomasw@gmail.com> writes:

> On Tue, Jun 24, 2008 at 5:03 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> Tomas Winkler <tomasw@gmail.com> writes:
>>
>>>> What about b-only devices?
>>>
>>> See the log message...(known issue). Currently you have to loop over
>>> rates to get this info. I wasn't sure if they are any b-only NICs
>>> under mac80211 so I didn't run to implement it.
>>
>> at76_usb will be 11b only mac80211 driver whenever we manage to
>> complete the port.
>
> Then pls, look at the V2 of this patch if this work for you.

I haven't worked with at76_usb in a long time. But if I find time, I
can test this. But it might take a while :(

-- 
Kalle Valo
