Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59604 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab0G0P5O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 11:57:14 -0400
Received: by pwi5 with SMTP id 5so508063pwi.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 08:57:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727140139.GA31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
	<20100727140139.GA31694@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 08:56:54 -0700
Message-ID: <AANLkTimS2d0jZnu-44+cbFQXvitj_3Rq3egttgOzEiRh@mail.gmail.com>
Subject: Re: Confused - bisecting wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 7:01 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Mon, Jul 26, 2010 at 08:27:06PM -0700, Luis R. Rodriguez wrote:
>> 04:23  * mcgrof is confused, I just did a git bisect -i on
>> wireless-testing on some patch on Fri Jul 2 00:09:49 2010  and ended
>> up with a 2.6.34 top level
>>           Makefile
>> 04:23 < mcgrof> it was git rebase -i ba17bc5e55ba541d2a8765fca53b6883b667ab21
>> 04:23 < mcgrof> eh
>> 04:24 < mcgrof> how am I supposed to bisect wl now
>> 04:24 < mcgrof> the odd thing though is that the top commit is ancient
>> 04:24 < mcgrof> http://paste.pocoo.org/show/242077/
>> 04:24 < mcgrof> but the other ones are OK
>>
>> I realize we should use wireless-2.6.git to bisect stable but I need
>> to bisect against recent patches that spans different master- tags
>> from you, I figured git bisecting wireless-testing would work now that
>> you are using a different method to move your tree forward but am I
>> wrong? Should I only bisect between master tags still?
>
> wireless-testing is a nasty mess when it comes to bisection.
> I am considering a one-time rebase of wireless-testing after the
> next -rc1, now that the current process is working reasonably well.
> wireless-testing will continue to have a messy history, but it should
> be a bit less nasty after a rebase.
>
> As for right now, it sounds like you should just use wireless-next-2.6
> instead?

Oh OK, didn't realize that was bisectable, thanks. Also was unsure if
I'd get other subsystems's -next components. Is wireless-next.git just
the -next bits for 802.11 or does it also suck up net-next?

  Luis
