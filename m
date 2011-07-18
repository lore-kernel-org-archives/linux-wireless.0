Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:48547 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab1GRJhA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 05:37:00 -0400
To: "Kahn\, Gery" <geryk@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
	<CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com>
	<87aaccvaxr.fsf@purkki.adurom.net> <8762n0ukdu.fsf@purkki.adurom.net>
	<CABB-i1fk3i5HOWEsgVSaQcE2-Bu8cYdnDH9pKjP7eeRS2oaUxg@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 18 Jul 2011 12:36:58 +0300
In-Reply-To: <CABB-i1fk3i5HOWEsgVSaQcE2-Bu8cYdnDH9pKjP7eeRS2oaUxg@mail.gmail.com> (Gery Kahn's message of "Mon\, 18 Jul 2011 11\:39\:18 +0300")
Message-ID: <87wrfgszet.fsf@purkki.adurom.net> (sfid-20110718_113706_356669_63C549E9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Kahn, Gery" <geryk@ti.com> writes:

> On Mon, Jul 18, 2011 at 10:18, Kalle Valo <kvalo@adurom.com> wrote:
>> Kalle Valo <kvalo@adurom.com> writes:
>>
>>>> After some investigation, found that ethtool's ioctl interface
>>>> doesn't work at this case.
>>>
>>> This reminds me: I have patches for these issues but I never sent them
>>> upstream. It's too late for me now, but I'll search them tomorrow (or
>>> today to be exact..) and send them for testing purposes.
>>
>> Here's the patch I used:

[...]

> Tested-by: Gery Kahn <geryk@ti.com>

Thanks for testing. I'm busy with somethign else today, but I'll send
a proper patch tomorrow with your tested-by.

-- 
Kalle Valo
