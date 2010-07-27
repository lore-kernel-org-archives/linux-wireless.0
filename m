Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37229 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab0G0Rgd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 13:36:33 -0400
Received: by vws3 with SMTP id 3so3666204vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 27 Jul 2010 10:36:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100727171850.GD31694@tuxdriver.com>
References: <AANLkTim-0qoS7o+fcQ6uA18AC_gQSiiDe4Tv_L1FT1Ae@mail.gmail.com>
	<20100727140139.GA31694@tuxdriver.com> <AANLkTimS2d0jZnu-44+cbFQXvitj_3Rq3egttgOzEiRh@mail.gmail.com>
	<20100727160434.GB31694@tuxdriver.com> <AANLkTi=x7FzdRoC6DxeahvSm+2teN__TsoKjxphOMiPP@mail.gmail.com>
	<20100727163141.GC31694@tuxdriver.com> <AANLkTi=Yan5f7hcGm-GTDL=aJ_Oc-U8JExZXMZdr+MPZ@mail.gmail.com>
	<20100727171850.GD31694@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 27 Jul 2010 10:36:08 -0700
Message-ID: <AANLkTikEy=_tsTN9jUXoTaQ3ynbYTGxWuHUOoe16LnAU@mail.gmail.com>
Subject: Re: Confused - bisecting wireless-testing
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 27, 2010 at 10:18 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Tue, Jul 27, 2010 at 09:54:20AM -0700, Luis R. Rodriguez wrote:
>
>> So I guess the next question is where does David base his net-next.git
>> off from? Will it only include 802.11 / Ethernet / Wimax / netcore /
>> etc next bits or is there more? I ask to know what I'm in for in case
>> I want to bisect from it or derivatives (wireless-next.git).
>
> Generally he branches from linux-2.6 at around -rc1 (and sometimes
> before) and then doesn't pull again until after the release.

Thanks this helps a lot!

  Luis
