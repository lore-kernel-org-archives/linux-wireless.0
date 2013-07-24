Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:50584 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab3GXR61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jul 2013 13:58:27 -0400
Received: by mail-wg0-f47.google.com with SMTP id j13so707219wgh.2
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jul 2013 10:58:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51EFF3DD.80000@lwfinger.net>
References: <CA+Gu+Kx3RNkenmHD4dGP5NxC1zzq9sxwjdRxuj5qLFCg32DLeQ@mail.gmail.com>
	<CA+Gu+Ky5rCwCrWJkCKXsPEFodaARdf5DkmES3TN_UNuUqTnYVA@mail.gmail.com>
	<51EFF3DD.80000@lwfinger.net>
Date: Thu, 25 Jul 2013 01:58:26 +0800
Message-ID: <CA+Gu+KzKhWs5_U-6wQSLT4s2STZBGH8-z4r5cM9zE1tEEFvnKw@mail.gmail.com> (sfid-20130724_195830_714976_FF92352D)
Subject: Re: Fwd: TP-LINK 8200ND
From: Vihang Patel <vihang08@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry,

I have already tried the Ndiswrapper using both the TP-Link provided
Windows XP(64 & 32bit) drivers as well as ones provided by Realtek on
Ubuntu 12.04 and 13.04. Both scenarios freezes the OS. And in scenario
that I save it in conf file for it to load on startup, the OS freezes
on startup. No luck there. Would be interesting to see if anyone else
got it to work using ndiswrapper.

Vihang

On Wed, Jul 24, 2013 at 11:33 PM, Larry Finger
<Larry.Finger@lwfinger.net> wrote:
> On 07/24/2013 08:50 AM, Vihang Patel wrote:
>>
>> Hi,
>>
>> I understand there was a thread on linux drivers for TP-LINK8200ND
>> with rtl8192cu chipset, but it ran cold with no resolution. I was
>> wondering if there if anyone found a resolution on that.
>>
>> I have tried installing the drivers provided by realtek as well on
>> both Ubuntu 12.004 and 13.04. Scorched the internet, and was able to
>> get it to detect the device but it wont connect to any of the Wireless
>> networks.
>>
>> Any help would be helpful.
>
>
> The USB ID has been added to the mainline and stable kernels; however, the
> device does not work for me. The latest vendor driver sent privately to me
> can make a connection; however, the throughput is less than 1 Mbps. I have
> not yet had a chance to investigate as this card is low on my priority list.
>
> I have added the Realtek developer to this reply (Bcc). Perhaps the company
> has made some progress; however, when I last contacted them, they did not
> have an instance of this particular card. It seems that your only viable
> option at this time would probably be the Windows driver with ndiswrapper. I
> have not tested this option.
>
> Larry
>
>
