Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:43449 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZKEBk7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2009 20:40:59 -0500
MIME-Version: 1.0
In-Reply-To: <4AF22A99.7050407@kernel.org>
References: <43e72e890911041540hd1e5f87u8d282d9c95857504@mail.gmail.com>
	<alpine.LFD.2.01.0911041551220.31845@localhost.localdomain>
	<43e72e890911041616w547fc9e4t34915827f65c2682@mail.gmail.com>
	<4AF22A99.7050407@kernel.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 4 Nov 2009 17:40:44 -0800
Message-ID: <43e72e890911041740p2095f3bdqf576c0730f1a850e@mail.gmail.com>
Subject: Re: Reverting 5d423 fixes loading of ath9k on Acer Extensa 7630EZ
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Yannick Roehlly <yannick.roehlly@free.fr>,
	Jesse Barnes <jesse.barnes@intel.com>,
	Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
	Andrew Morton <akpm@linux-foundation.org>,
	"John W. Linville" <linville@tuxdriver.com>, berndl81@gmx.at,
	Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 4, 2009 at 5:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Luis R. Rodriguez wrote:
>> On Wed, Nov 4, 2009 at 3:57 PM, Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> On Wed, 4 Nov 2009, Luis R. Rodriguez wrote:
>>>> Can you please consider reviewing this issue and help determine if
>>>> this indeed needs to be reverted for 2.6.32 and the next 2.6.31.y.
>>>>
>>>> I am curious if other devices would work by reverting this as well.
>>>> [ ... ] For details please feel free to check:
>>>>
>>>> http://bugzilla.kernel.org/show_bug.cgi?id=14402
>>> That same commit was the cause for
>>>
>>>        http://bugzilla.kernel.org/show_bug.cgi?id=13940
>>>
>>> and we just increased the rounding to make it go away (see commit
>>> 15b812f1). But that was a hack.
>>>
>>> And if that didn't help the ath9k case, then we should just revert
>>> entirely.
>>
>> Alright, will see if Bernhard is up for testing the 15b812f1 hack and
>> report back.
>
> can you post whole boot log with debug?

You can find the logs without 15b812f1 on the bug report. I'll poke
Bernhard to poke logs with 15b812f1 applied.

  Luis
