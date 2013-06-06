Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:60952 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3FFJFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jun 2013 05:05:05 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so31103wgh.28
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jun 2013 02:05:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51B04585.9020108@gmx.net>
References: <CAB-Tk70FmmfZOaJnWOubcOrP3MyXebTtrY936_4NROmf_76EZw@mail.gmail.com>
	<CAB-Tk73mTDsvf+MCEq5xfUBUtE4c6KfL2nkAcZe2LCY5pF=7RQ@mail.gmail.com>
	<CAJ-Vmok5yLZvstvYHi35ALWG3q8sVYLx_1PuhL31unOjxrg-4g@mail.gmail.com>
	<201306052335.25953.chunkeey@googlemail.com>
	<CAJ-Vmom6cmf-c-TJs5s9AvT953m0+tANVj_AxnSYwUCzegyPWQ@mail.gmail.com>
	<CAB-Tk7273qtgA0J-rvpFxNbMDErmXVdknybVOJmUTa73VhL1Cw@mail.gmail.com>
	<51B04585.9020108@gmx.net>
Date: Thu, 6 Jun 2013 17:05:03 +0800
Message-ID: <CAB-Tk73j8b12viR49rO8RcrZLYA7_G8Ti-qiYZW-ZCnemeaA2Q@mail.gmail.com> (sfid-20130606_110512_086260_46EDB993)
Subject: Re: carl9170:5/10 MHz Channel Support on carl9170
From: "C.B. Wang" <wtwangcb@gmail.com>
To: Oleksij Rempel <fishor@gmx.net>
Cc: Adrian Chadd <adrian@freebsd.org>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> True, but again look at the vendor driver. I think it should
>> be very easy to implement "set coverage class". The slot time
>> can be set by "AR9170_MAC_REG_SLOT_TIME" register and the ack
>> timeout should be in "AR9170_MAC_REG_ACK_EXTENSION". That's
>> all the information I have. So what are you waiting for

In addition to what you have said above,can we also make longer range
communication
possible by sacrificing data rates and using 5/10 MHz narrow channels
which is Atheros's
extended range(xr) technology?


On 6/6/13, Oleksij Rempel <fishor@gmx.net> wrote:
> Am 06.06.2013 10:07, schrieb C.B. Wang:
>> Spectral analysis isn't supported by any Atheros USB chipsets,is it?
>
> ar7010 devices theoretically should support it.
>
>> The 802.11j standard defines 10mhz operation.I think it is mandatory.
>> You can get a copy here
>> http://www.it.iitb.ac.in/~mukesh/dokuwiki/lib/exe/fetch.php?cache=cache&media=mtp:802.11j-2004.pdf
>>
>> No,I don't know any.Most devices that use ZyDaS chipset are b/g
>> soloution.
>> It's rare even to see an a/b/g ZyDaS device.
>>
>> Channel 183(4815mhz),185(4925mhz),187(4935mhz),189(4945mhz) should also
>> be added to the channel list of carl9170 driver.
>>
>
>
>
