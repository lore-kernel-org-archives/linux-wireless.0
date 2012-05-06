Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39671 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab2EFJXU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 05:23:20 -0400
Received: by lahj13 with SMTP id j13so2858160lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 02:23:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120506085902.GC1288@ritirata.org>
References: <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
	<20120504002136.GA4201@ritirata.org>
	<CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
	<20120504063644.GA2912@ritirata.org>
	<CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
	<20120504142006.GA2040@ritirata.org>
	<CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
	<CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
	<20120506075433.GA1288@ritirata.org>
	<CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
	<20120506085902.GC1288@ritirata.org>
Date: Sun, 6 May 2012 12:23:18 +0300
Message-ID: <CANUX_P3+TkK-OfXJuvWvFK3uMZT0kYUnbreLOWoNVU51VMdndw@mail.gmail.com> (sfid-20120506_112324_776029_96814A11)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 6, 2012 at 11:59 AM, Antonio Quartulli <ordex@autistici.org> wrote:
> On Sun, May 06, 2012 at 11:26:32 +0300, Emmanuel Grumbach wrote:
>> All right,
>>
>> Can you please test the patch I sent to you (which was good but not enough)
>> And add this one too ?
>
> What branch are these patches based on?
> I'm applying them onto wireless-testing, but I always messages like:
>
> patching file drivers/net/wireless/iwlwifi/iwl-debugfs.c
> Hunk #1 succeeded at 2211 (offset 1 line).
>

This is fine

> The patches apply anyway, but just to be sure I'm testing the correct branch
>
>
> Cheers,
>
>>
>> Thanks
>>
>> Emmanuel Grumbach
>> egrumbach@gmail.com
>>
>>
>> On Sun, May 6, 2012 at 10:54 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> > On Sun, May 06, 2012 at 08:49:52 +0300, Emmanuel Grumbach wrote:
>> >> wait - I just noticed that this one introduced another issue...
>> >
>> > ok, I'll drop this patch
>> >
>> >>
>> >> Emmanuel Grumbach
>> >> egrumbach@gmail.com
>> >>
>> >>
>> >> On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>> >> > Well,
>> >> >
>> >> > this is not the same warning as before.
>> >> > Can you try the patch attached ?
>> >> > I have submitted it internally.
>> >> >
>> >> > thanks
>> >> >
>> >> > Emmanuel Grumbach
>> >> > egrumbach@gmail.com
>> >> >
>> >> >
>> >> > On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici.org> wrote:
>> >> >> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
>> >> >>> This can't be with my patch, is it ?
>> >> >>
>> >> >> here is the log. Some pieces are missing at the beginning, didn't check why.
>> >> >> However the WARNING comes up later, so it should be ok. Tell me if I can do
>> >> >> something else!
>> >> >>
>> >> >> Cheers,
>> >> >>
>> >> >>
>> >> >> --
>> >> >> Antonio Quartulli
>> >> >>
>> >> >> ..each of us alone is worth nothing..
>> >> >> Ernesto "Che" Guevara
>> >
>> > --
>> > Antonio Quartulli
>> >
>> > ..each of us alone is worth nothing..
>> > Ernesto "Che" Guevara
>
>
>
> --
> Antonio Quartulli
>
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara
