Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:42222 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1GQVpH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jul 2011 17:45:07 -0400
To: "Kahn\, Gery" <geryk@ti.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
	<CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 18 Jul 2011 00:45:04 +0300
In-Reply-To: <CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com> (Gery Kahn's message of "Sun\, 17 Jul 2011 15\:51\:47 +0300")
Message-ID: <87aaccvaxr.fsf@purkki.adurom.net> (sfid-20110717_234510_602098_9A2ADC78)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Kahn, Gery" <geryk@ti.com> writes:

Hi Gery,

> On Sun, Jul 17, 2011 at 11:16, Kahn, Gery <geryk@ti.com> wrote:
>> On Fri, Jul 15, 2011 at 13:56, Kalle Valo <kvalo@adurom.com> wrote:
>>> Gery Kahn <geryk@ti.com> writes:
>>>
>>>> Export the chip id to userspace. This helps to change application behavior
>>>> according to architecture of the wl12xx chip.
>>>
>>> We already support exporting this type of information through
>>> ethtool's ioctl interface using the wiphy.hw_version, which was
>>> specifially added for this purpose. That's much better than yet
>>> another sysfs file.
>>>
>> Right.
>> In PLT mode it didn't show any information, but
>> that might have been a mistake on our part.
>>
>> I'll send another patch.
>>
> After some investigation, found that ethtool's ioctl interface doesn't work
> at this case.

This reminds me: I have patches for these issues but I never sent them
upstream. It's too late for me now, but I'll search them tomorrow (or
today to be exact..) and send them for testing purposes.

If I forget, please ping me :)

-- 
Kalle Valo
