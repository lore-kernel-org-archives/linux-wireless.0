Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38015 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2EFJ0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 05:26:40 -0400
Received: by lbbgm6 with SMTP id gm6so2873402lbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 May 2012 02:26:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1Sg6=NNYoRJ+zOHyjiyKXfY=q+R4eDpqLtTC3DaodbfQ@mail.gmail.com>
References: <20120504002136.GA4201@ritirata.org>
	<CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
	<20120504063644.GA2912@ritirata.org>
	<CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
	<20120504142006.GA2040@ritirata.org>
	<CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
	<CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
	<20120506075433.GA1288@ritirata.org>
	<CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
	<20120506085637.GB1288@ritirata.org>
	<20120506091526.GA2086@ritirata.org>
	<CANUX_P1Sg6=NNYoRJ+zOHyjiyKXfY=q+R4eDpqLtTC3DaodbfQ@mail.gmail.com>
Date: Sun, 6 May 2012 12:26:38 +0300
Message-ID: <CANUX_P0g5TAQ=+VO0EXUvVhNOf6zy-h7KQLocLY0RaVAaJo2FQ@mail.gmail.com> (sfid-20120506_112644_023509_165643A3)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> >
>>> > Can you please test the patch I sent to you (which was good but not enough)
>>> > And add this one too ?
>>>
>>> Ok, I'll also leave the print.patch.
>>> I'll report the result.
>>>
>>
>> The WARNING is gone :)
>>
>> I attached the dmesg log anyway (debug was off, but there
>> are all the prints you introduced).
>>
>> To be sure, I also removed all the IWL_ERR you added and tried to reboot (in
>> order to see whether the printings were affecting synchronization).
>>
>
> Glad to hear.
>
> You can also remove everything. Reapply the second patch, and here is
> a new version of this patch after cleaning.

I meant, reapply the first patch (the one that zeroes the TBs).
