Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:46556 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbbBVV4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Feb 2015 16:56:53 -0500
Received: by mail-ob0-f181.google.com with SMTP id vb8so33156608obc.12
        for <linux-wireless@vger.kernel.org>; Sun, 22 Feb 2015 13:56:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAM9PttgYK3e75c2XZ6G2nPXw=UR95-xVwO0LBqrXRPFcABkgTA@mail.gmail.com>
References: <CA+55aFz0uxAA+W0ekMwEgMS-TtqtO8hdzpgrOPvn8hv8c11BKQ@mail.gmail.com>
 <CAJ-VmonjXw3_swWQe=gDcARwaFYN06wxF-tBBMB3jhp1f-KZxg@mail.gmail.com>
 <CA+55aFxd-m+xj444yL0WqiTMvN8_4vT+m0Zue31Vt4shFYOEKA@mail.gmail.com>
 <CAA93jw4yckBgpoBf_ysDd2s8rJ5HKgx7VoTP9tnkPeSt6jn_2w@mail.gmail.com>
 <CA+55aFxeuR2PidybZa-YBnqFW541AZ_vFkwvBXqL61OB-JxRew@mail.gmail.com> <CAM9PttgYK3e75c2XZ6G2nPXw=UR95-xVwO0LBqrXRPFcABkgTA@mail.gmail.com>
From: Kyle Bassett <kylebassett@gmail.com>
Date: Sun, 22 Feb 2015 16:56:32 -0500
Message-ID: <CAM9Ptti8YfufuVXcGUqRUNAAk6qvO9-VR+p5F61EzzP-wxVJew@mail.gmail.com> (sfid-20150222_225656_394685_353FFEBD)
Subject: Re: [ath9k-devel] AR9462 problems connecting again..
Cc: Linux Wireless List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 22, 2015 at 4:54 PM, Kyle Bassett <kylebassett@gmail.com> wrote:
> On Sun, Feb 22, 2015 at 4:45 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> On Sun, Feb 22, 2015 at 10:58 AM, Dave Taht <dave.taht@gmail.com> wrote:
>> >
>> > Hint: Several unifi (and most ubnt) products are well supported by
>> > openwrt directly,
>>
>> I want Linux to "just work". None of this "oh, you can change
>> something else and it probably works".  I want to fix the problem in
>> *linux*.
>>
>>
>> There's clearly something wrong with the AR9462 driver and/or how it
>> uses the wireless infrastructure, and it should be fixed. Not worked
>> around with "use some other AP software".
>>
>


A side note on this, what is the current method for unit testing WAP's and
client devices?  I'm sure every vendor has their own flavor, although I feel
some clearly defined FOSS method should exist as well.

I bring this up is because I have personally experienced bugs inside the
UniFi offerings, and on miscellaneous Linux/non-linux client devices as
well.
