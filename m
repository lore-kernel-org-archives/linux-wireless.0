Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:52287 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634AbZLJQOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Dec 2009 11:14:48 -0500
Received: by iwn1 with SMTP id 1so5460642iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Dec 2009 08:14:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091210150318.GB2955@tuxdriver.com>
References: <20091209211054.GB32058@tuxdriver.com> <87ljhb0x0h.fsf@purkki.valot.fi>
	<20091210134733.GC11112@tuxdriver.com> <87ein30vt4.fsf@purkki.valot.fi>
	<43e72e890912100631if1c17b2l597168813db4a19c@mail.gmail.com>
	<20091210143754.GA2955@tuxdriver.com> <43e72e890912100653p3890705u4f88dd19026a5877@mail.gmail.com>
	<20091210150318.GB2955@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 10 Dec 2009 08:14:34 -0800
Message-ID: <43e72e890912100814u45a58c47j5dfd66769f8170b@mail.gmail.com>
Subject: Re: Revised wireless tree management practices
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org,
	davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 7:03 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Dec 10, 2009 at 06:53:43AM -0800, Luis R. Rodriguez wrote:
>> On Thu, Dec 10, 2009 at 6:37 AM, John W. Linville
>> <linville@tuxdriver.com> wrote:
>> > On Thu, Dec 10, 2009 at 06:31:02AM -0800, Luis R. Rodriguez wrote:
>> >> On Thu, Dec 10, 2009 at 6:04 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
>> >> > "John W. Linville" <linville@tuxdriver.com> writes:
>> >> >
>> >> >> I still see value in a tree that has a reasonably stable base and
>> >> >> contains both wireless fixes and wireless features.
>> >> >
>> >> > I agree, it makes things a lot easier.
>> >> >
>> >> >> So, I think wireless-testing remains as the focal point for wireless
>> >> >> LAN testing and development. I'll just be getting patches there in a
>> >> >> slightly different process.
>> >> >
>> >> > Sounds very good. So I'll continue using wireless-testing. Thanks.
>> >>
>> >> But we use wireless-next as base though if we want to send you pull
>> >> requests, ay?
>> >
>> > Yes, that is correct -- people that want to send patches (or simply
>> > test) should use wireless-testing.  People that want to send pull
>> > requests need to have trees based on wireless-2.6 (for fixes)
>>
>> Typically we have relied on you to push fixes into wireless-2.6, does
>> this change a bit now in that we should try to keep better track of
>> stable fixes and send them to you instead if we're doing the pull
>> request method?
>
> Yes.  If you want me to do git pulls then you need to separate fixes
> into a tree based on wireless-2.6.  Also, you should be conscientious
> about adding "Cc: stable@kernel.org" to commit logs as appropriate.
> The whole point of the pulls is to keep me from having to touch
> the patches.

OK last question, is if we do take up the pull request method for
ath9k at Atheros we still have people sending patches from the
community so who would pick those up. Is it easier for you if we do so
and then get them to you through our pull request? How about the
stable fixes? Reason I ask if you pick some of these up it just means
we need to rebase and I do prefer to keep a clean tree myself as well,
although not required at all.

  Luis
