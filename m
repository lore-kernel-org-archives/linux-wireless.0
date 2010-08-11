Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46539 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757840Ab0HKByl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Aug 2010 21:54:41 -0400
Received: by wwj40 with SMTP id 40so13669416wwj.1
        for <linux-wireless@vger.kernel.org>; Tue, 10 Aug 2010 18:54:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1281481505.20038.10.camel@wwguy-ubuntu>
References: <AANLkTim4_HoHwdhGqAZqcGf2oq7boktdZFW4-w5DpdDa@mail.gmail.com>
 <AANLkTinuYOvwNZAFgq67f4XBL4YQ+b2z4EBMcmvbMYi3@mail.gmail.com> <1281481505.20038.10.camel@wwguy-ubuntu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 10 Aug 2010 21:54:20 -0400
Message-ID: <AANLkTimU6qzoe2KS59zbN1Kxgh0KU0PO3aMaXz--st93@mail.gmail.com>
Subject: Re: [WTF, maintainers] Re: *PING* iwlagn 2.6.35: "BA scd_flow 0 does
 not match txq_id 10" regression
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 10, 2010 at 7:05 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Andrew,
>
> On Tue, 2010-08-10 at 14:39 -0700, Andrew Lutomirski wrote:
>> On Mon, Jul 26, 2010 at 4:02 PM, Andrew Lutomirski <luto@mit.edu> wrote:
>> > There's a regression in 2.6.35 where the connection breaks and iwlagn
>> > writes a bunch of:
>> >
>> > iwlagn 0000:03:00.0: BA scd_flow 0 does not match txq_id 10
>> >
>> > This is confirmed [1] and a patch supposedly exists.  Since this
>> > breaks at least two people's wireless and 2.6.35 is about to be
>> > released, can we see the patches?
>> >
>> > Thanks,
>> > Andy
>> >
>> > [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/53552
>> >
>>
>> This regression was reported on July 21 and confirmed, supposedly with
>> a patch available, on July 24 (or maybe July 23).  On July 26 I pinged
>> the list because I'm affected as well.
>>
>> It's now August 10 and both 2.6.35 and 2.5.35.1 have been released and
>> the bug is still there.  WTF happened?  (I admit I haven't actually
>> tested 2.6.35.1 because it's still compiling, but I see nothing to
>> suggest that it's been fixed.)
>>
>
> Sorry for the delay, the problem you report is a real problem in our
> uCode; unfortunately, we still not root cause the real problem yet. The
> patch I provide previous just a hack and still waiting for our internal
> validation team to make sure it did not break the overall behaviors.

Fair enough.

>
> I will submit the patch as soon as I got the report back from our test
> team; at the meantime, we are very active work on root cause the real
> problem. Once we have the possible solution, it will be great if you can
> help us to verify it.
>

I'll do my best, but I'm don't know how easily I can reproduce this.
I only rarely get the messages, but I have random problems connecting
fairly frequently.

--Andy

> Best regards
> Wey
>>
>> P.S.  iwlagn malfunctions for me *all the time*.  I'd love to help
>> debug but it's hard when no one pays attention and when the bugs are
>> all hard to trigger.  Any volunteers to help?
>
>
