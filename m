Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:26778 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYKJPm7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 10:42:59 -0500
Received: by an-out-0708.google.com with SMTP id d40so349226and.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 07:42:56 -0800 (PST)
Message-ID: <31436f4a0811100742p6154e2f9p34f3dfb1de2f71e3@mail.gmail.com> (sfid-20081110_164314_464529_D6722990)
Date: Mon, 10 Nov 2008 17:42:56 +0200
From: "David Shwatrz" <dshwatrz@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Where is allow-ap-vlan-modes.patch ?
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081110142806.GG3546@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com>
	 <200811091604.43705.IvDoorn@gmail.com>
	 <31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com>
	 <874p2g0x9d.fsf@nokia.com> <20081110142806.GG3546@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
First, I hope you feel better soon.

Second:
Looking at the patches at the mailing list, I do not see
that anywhere it says against which git tree they were made.
It could be : wireless-next-2.6,wireless-2.6, and wireless-testing.

I guess that there are many cases in which a patch can be applied to
two of these trees (or maybe all three of them),
whereas there are times in which it can be applied to only one git tree.

How is it determined to which tree the patches should be
applied ?

Rgs,
DS

On Mon, Nov 10, 2008 at 4:28 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Nov 10, 2008 at 11:02:22AM +0200, Kalle Valo wrote:
>> David Shwatrz <dshwatrz@gmail.com> writes:
>>
>> > In this occasion may I ask - what is the wireless-testing git tree?
>> > is it based on wireless-next-2.6 or on wireless-2.6 tree?
>>
>> It's based on Linus' rc releases and has all the wireless patches
>> which have been under development. I think John cherry picks the
>> patches from wireless-testing to wireless-2.6 or wireless-next-2.6. So
>> wireless-testing contains the bleeding edge wireless patches and if
>> John thinks they are good enough, he submits them forward.
>>
>> Please correct me if I have understood something wrong.
>
> That is basically right.
>
> In the past patches often went to wireless-testing and to
> wireless-next-2.6/wireless-2.6 at the about the same time.  However
> upstream standards have tightened in ways that make me feel it is
> appropriate to give patches more public testing even before sending
> them for -next.
>
> In this case, I was also sick all last week which has slowed thing
> a bit more...
>
> Thanks,
>
> John
> --
> John W. Linville                Linux should be at the core
> linville@tuxdriver.com                  of your literate lifestyle.
>
