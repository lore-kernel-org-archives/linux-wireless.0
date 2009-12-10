Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:33158 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbZLJOx5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 09:53:57 -0500
Received: by iwn1 with SMTP id 1so5399259iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 06:54:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091210143754.GA2955@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi>
	<20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi>
	<43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com>
	<20091210143754.GA2955@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Dec 2009 06:53:43 -0800
Message-ID: <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com>
Subject: Re: Revised wireless tree management practices
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 6:37 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Dec 10, 2009 at 06:31:02AM -0800, Luis R. Rodriguez wrote:
>> On Thu, Dec 10, 2009 at 6:04 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> > "John W. Linville" <linville@tuxdriver.com> writes:
>> >
>> >> I still see value in a tree that has a reasonably stable base and
>> >> contains both wireless fixes and wireless features.
>> >
>> > I agree, it makes things a lot easier.
>> >
>> >> So, I think wireless-testing remains as the focal point for wireless
>> >> LAN testing and development. I'll just be getting patches there in a
>> >> slightly different process.
>> >
>> > Sounds very good. So I'll continue using wireless-testing. Thanks.
>>
>> But we use wireless-next as base though if we want to send you pull
>> requests, ay?
>
> Yes, that is correct -- people that want to send patches (or simply
> test) should use wireless-testing.  People that want to send pull
> requests need to have trees based on wireless-2.6 (for fixes)

Typically we have relied on you to push fixes into wireless-2.6, does
this change a bit now in that we should try to keep better track of
stable fixes and send them to you instead if we're doing the pull
request method?

> and/or
> wireless-next-2.6 (for features).  If you are sending pull requests
> and have a feature that depends on a fix then we'll have to coordinate
> to make sure the right bits get into the right trees.

OK, got it.

  Luis
