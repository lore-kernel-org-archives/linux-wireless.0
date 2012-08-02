Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout6.freenet.de ([195.4.92.96]:42795 "EHLO mout6.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2HBTYD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 15:24:03 -0400
Message-ID: <501AD349.2010106@01019freenet.de> (sfid-20120802_212407_745302_DE839960)
Date: Thu, 02 Aug 2012 21:21:45 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Emmanuel Grumbach <egrumbach@gmail.com>
CC: "Ch. Hanisch" <ch-hanisch@t-online.de>,
	linux-wireless@vger.kernel.org
Subject: Re: No WLAN on DELL XPS L702x with Ubuntu 12.04LTS (64Bit)
References: <5016F03F.1020508@t-online.de> <5016F59E.9070101@01019freenet.de> <CANUX_P2CZW5ji--KkXoyBZUuZfOqkPk_A8Ui9tw4rNeuY=mebQ@mail.gmail.com> <5019EC7D.5030208@01019freenet.de> <CANUX_P10yfdy+d9txsp1RV9niKex_5WAr0VFsjsMiPosv6M+mA@mail.gmail.com> <20120802165429.29839020@dualc.maya.org> <CANUX_P1corc7rp_MRrV=MuDRXqqibmxL9MXwhE=zrkNSNfWqzg@mail.gmail.com>
In-Reply-To: <CANUX_P1corc7rp_MRrV=MuDRXqqibmxL9MXwhE=zrkNSNfWqzg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach wrote:
>>>>
>>>> He wrote, too, that the installation of compat-wireless
>>>> (unfortunately, he didn't told me which version), didn't changed the
>>>> situation.
>>>>
>>>> I attached for him the output of
>>>> options iwlwifi debug=0xffffffff
>>>>
>>>> The last part of it:
>>>
>>> what about the logs *before* that?
>>
>> What are you missing? The attachment contains of 1739 lines. It seems to
>> be the complete output from dmesg from 0 to 675 seconds!
>>
> Sorry - I missed the attached file. Ok so you are using the latest fw
> and you get a FW in INIT stage.

Is there another firmware around? What's the filename / path of this
firmware file? I can't find it in the debug log.

@Christian:
You wrote about another machine, which runs fine with the same hardware.
Which firmware do you use in this case? Maybe, you could try to copy the
firmware from the working machine to the broken one? Please do a copy of
the new firmware file!


> Please file a bug.
> I thought it would be a quick and easy issue - but apparently it is not... Sorry


Thanks Emmanuel,
kind regards,
Andreas

