Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59346 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2EFFtz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 01:49:55 -0400
Received: by werb10 with SMTP id b10so653684wer.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 May 2012 22:49:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
References: <20120502162100.GA2528@ritirata.org>
	<20120503065351.GB2307@ritirata.org>
	<CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
	<CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
	<20120503200948.GC11326@ritirata.org>
	<CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
	<20120504002136.GA4201@ritirata.org>
	<CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
	<20120504063644.GA2912@ritirata.org>
	<CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
	<20120504142006.GA2040@ritirata.org>
	<CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
Date: Sun, 6 May 2012 08:49:52 +0300
Message-ID: <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com> (sfid-20120506_075037_223231_FACE8C48)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wait - I just noticed that this one introduced another issue...

Emmanuel Grumbach
egrumbach@gmail.com


On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Well,
>
> this is not the same warning as before.
> Can you try the patch attached ?
> I have submitted it internally.
>
> thanks
>
> Emmanuel Grumbach
> egrumbach@gmail.com
>
>
> On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici.org> wrote:
>> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
>>> This can't be with my patch, is it ?
>>
>> here is the log. Some pieces are missing at the beginning, didn't check why.
>> However the WARNING comes up later, so it should be ok. Tell me if I can do
>> something else!
>>
>> Cheers,
>>
>>
>> --
>> Antonio Quartulli
>>
>> ..each of us alone is worth nothing..
>> Ernesto "Che" Guevara
