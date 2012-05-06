Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:49300 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab2EFJ6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 05:58:18 -0400
Received: by lahj13 with SMTP id j13so2865550lah.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 02:58:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120506095750.GB21716@ritirata.org>
References: <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
	<20120504142006.GA2040@ritirata.org>
	<CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
	<CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
	<20120506075433.GA1288@ritirata.org>
	<CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
	<20120506085637.GB1288@ritirata.org>
	<20120506091526.GA2086@ritirata.org>
	<CANUX_P1Sg6=NNYoRJ+zOHyjiyKXfY=q+R4eDpqLtTC3DaodbfQ@mail.gmail.com>
	<CANUX_P0g5TAQ=+VO0EXUvVhNOf6zy-h7KQLocLY0RaVAaJo2FQ@mail.gmail.com>
	<20120506095750.GB21716@ritirata.org>
Date: Sun, 6 May 2012 12:58:17 +0300
Message-ID: <CANUX_P25q-CM8WX7R2v5XsPaLa6B72rGFC95dTeaz_EqxLoZ0Q@mail.gmail.com> (sfid-20120506_115821_466006_18EAFA20)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> >>> > Can you please test the patch I sent to you (which was good but not enough)
>> >>> > And add this one too ?
>> >>>
>> >>> Ok, I'll also leave the print.patch.
>> >>> I'll report the result.
>> >>>
>> >>
>> >> The WARNING is gone :)
>> >>
>> >> I attached the dmesg log anyway (debug was off, but there
>> >> are all the prints you introduced).
>> >>
>> >> To be sure, I also removed all the IWL_ERR you added and tried to reboot (in
>> >> order to see whether the printings were affecting synchronization).
>> >>
>> >
>> > Glad to hear.
>> >
>> > You can also remove everything. Reapply the second patch, and here is
>> > a new version of this patch after cleaning.
>>
>> I meant, reapply the first patch (the one that zeroes the TBs).
>
> Do you think thise patches should be backported for stable? Doesn't seem to be
> trivial..
>

Well.... it seems that they need to... I will see what to do. For this
kind of things, I have a maintainer :-)
