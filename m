Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48993 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab0IREFb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 00:05:31 -0400
Received: by iwn5 with SMTP id 5so2494856iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 21:05:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100918001950.GA2178@tuxdriver.com>
References: <201009171148.39953.br1@einfach.org> <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
 <20100918001950.GA2178@tuxdriver.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 17 Sep 2010 21:01:46 -0700
Message-ID: <AANLkTi=r7cLbz_PY_EMgzXsG4v8OL=i10yfNeYE2oedg@mail.gmail.com>
Subject: Re: wireless-testing or wireless-next
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 5:19 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Thu, Sep 16, 2010 at 08:02:26PM -0700, Luis R. Rodriguez wrote:
>> On Thu, Sep 16, 2010 at 7:48 PM, Bruno Randolf <br1@einfach.org> wrote:
>> > John, Luis,
>> >
>> > I'm a little confused about which tree to use. I though we should base driver
>> > development on wireless-testing, but I see that you merge patches into
>> > wireless-next first. So should we re-base patches to wireless-next before we
>> > send them?
>>
>> Rule of thumb is if its large use linux-next, wireless-testing just
>> lets you actually boot a usable kernel.
>
> Actually, I generally prefer that patches target wireless-testing.
> In the even of conflicts between that and wireless-next-2.6, I can
> usually sort them out myself.  If not, I'll ask.

Ah thanks :)

>> > Also, AFAIK, compat-wireless is based on linux-next, so if I want to create a
>> > compat-wireless package based on my latest driver changes (I need to do this
>> > frequently for testing my driver on my platform), I always run into problems
>> > because my latest driver is in wireless-testing and not in linux-next. Do you
>> > have any advise on a proper workflow here?
>>
>> I have a "wl" branch for wireless-testing too :)  the master branch is
>> for linux-next.
>
> Actually, there will almost never be anything in wireless-testing
> that isn't in linux-next.  linux-next pulls from wireless-next-2.6,
> just as wireless-testing does.

True, except Ethernet updates get merged into linux-next too and I
rely on that for some of our Ethernet drivers updated too.

  Luis
