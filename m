Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:3371 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYKJSyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2008 13:54:46 -0500
Received: by qw-out-2122.google.com with SMTP id 3so1515745qwe.37
        for <linux-wireless@vger.kernel.org>; Mon, 10 Nov 2008 10:54:45 -0800 (PST)
Message-ID: <69e28c910811101054h55a20799o9ed3476f844077b0@mail.gmail.com> (sfid-20081110_195451_318322_906D46F0)
Date: Mon, 10 Nov 2008 19:54:45 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "David Shwatrz" <dshwatrz@gmail.com>
Subject: Re: Where is allow-ap-vlan-modes.patch ?
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Kalle Valo" <kalle.valo@nokia.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
In-Reply-To: <31436f4a0811100742p6154e2f9p34f3dfb1de2f71e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <31436f4a0811090701r4676409er8f53a32c91bc3ced@mail.gmail.com>
	 <200811091604.43705.IvDoorn@gmail.com>
	 <31436f4a0811100048h5c7520d3ga4eedd815f8c793a@mail.gmail.com>
	 <874p2g0x9d.fsf@nokia.com> <20081110142806.GG3546@tuxdriver.com>
	 <31436f4a0811100742p6154e2f9p34f3dfb1de2f71e3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 10, 2008 at 4:42 PM, David Shwatrz <dshwatrz@gmail.com> wrote:
> Hello,
> First, I hope you feel better soon.
>
> Second:
> Looking at the patches at the mailing list, I do not see
> that anywhere it says against which git tree they were made.
> It could be : wireless-next-2.6,wireless-2.6, and wireless-testing.
>
> I guess that there are many cases in which a patch can be applied to
> two of these trees (or maybe all three of them),
> whereas there are times in which it can be applied to only one git tree.
>
> How is it determined to which tree the patches should be
> applied ?
>
> Rgs,
> DS
>
> On Mon, Nov 10, 2008 at 4:28 PM, John W. Linville
> <linville@tuxdriver.com> wrote:
>> On Mon, Nov 10, 2008 at 11:02:22AM +0200, Kalle Valo wrote:
>>> David Shwatrz <dshwatrz@gmail.com> writes:
>>>
>>> > In this occasion may I ask - what is the wireless-testing git tree?
>>> > is it based on wireless-next-2.6 or on wireless-2.6 tree?
>>>
>>> It's based on Linus' rc releases and has all the wireless patches
>>> which have been under development. I think John cherry picks the
>>> patches from wireless-testing to wireless-2.6 or wireless-next-2.6. So
>>> wireless-testing contains the bleeding edge wireless patches and if
>>> John thinks they are good enough, he submits them forward.
>>>
>>> Please correct me if I have understood something wrong.
>>
>> That is basically right.
>>
>> In the past patches often went to wireless-testing and to
>> wireless-next-2.6/wireless-2.6 at the about the same time.  However
>> upstream standards have tightened in ways that make me feel it is
>> appropriate to give patches more public testing even before sending
>> them for -next.
>>
>> In this case, I was also sick all last week which has slowed thing
>> a bit more...
>>
>> Thanks,
>>
>> John
>> --
>> John W. Linville                Linux should be at the core
>> linville@tuxdriver.com                  of your literate lifestyle.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

The target tree used to be wireless-2.6's "everything" branch. There
was a lot of confusion over people mistakenly pulling "master" instead
of "everything" ("master" is the default), so the "everything" branch
was replaced by a separate repo, wireless-testing.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
