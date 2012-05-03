Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:62996 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECTzN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:55:13 -0400
Received: by were53 with SMTP id e53so1338382wer.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 12:55:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
References: <20120430145803.GE2630@ritirata.org>
	<20120430170337.GA2560@tuxdriver.com>
	<4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
	<CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
	<20120501183415.GG4316@ritirata.org>
	<20120501205616.GA2563@ritirata.org>
	<4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
	<CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
	<20120502153914.GA9285@tuxdriver.com>
	<20120502162100.GA2528@ritirata.org>
	<20120503065351.GB2307@ritirata.org>
	<CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
Date: Thu, 3 May 2012 22:55:12 +0300
Message-ID: <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com> (sfid-20120503_215540_760409_B02EA549)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

can you please apply the patch attached against wireless-testing ?

You will have quite a lot of prints, so you will probably need to send
/var/log/syslog or messages


Thanks

Emmanuel Grumbach
egrumbach@gmail.com


On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> Please enable CONFIG_FRAME_POINTERS
> Emmanuel Grumbach
> egrumbach@gmail.com
>
>
> On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistici.org> wrote:
>> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
>>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
>>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
>>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
>>> > > <meenakshi.venkataraman@intel.com> wrote:
>>> > > > Hi Antonio,
>>> > > >
>>> > > >>> it seems so. It happens at least once at boot time.
>>> > > >>> I will try wireless-testing and see what happens. Then I will apply your patch.
>>> > > >>
>>> > > >>The problem is there either with wireless-testing and with
>>> > > >>wireless-testing+your_patch.
>>> > > >>
>>> > > >>If it can somehow help, I also got several stack trace regarding intel_iova
>>> > > >>functions. But then the I got kernel panic and I was not able to copy the
>>> > > >>messages.
>>> > > >
>>> > > > [MV] Depending on how you set it up, perhaps the stack trace was saved in one of the syslog files in /var/log/...
>>> > > >
>>> > > > Thanks!
>>> > > > Meenakshi
>>> > > >
>>> > >
>>> > > Can you please re-run with debug=1 and send the whole log ?
>>> > > This will give a better indication on when the issue occurs.
>>> >
>>> > Does this help?
>>> >
>>> >     https://bugzilla.redhat.com/show_bug.cgi?id=815998#c18
>>>
>>> I applied patch in comment 17 on linux-3.3.4. IT didn't help but this time I got
>>> the WARNING even with debug=1. Log is attached.
>>>
>>
>>
>> Is there any particular kernel debugging option I could enable to make the log
>> more verbose?
>>
>>
>> Cheers,
>>
>>
>>
>> --
>> Antonio Quartulli
>>
>> ..each of us alone is worth nothing..
>> Ernesto "Che" Guevara
