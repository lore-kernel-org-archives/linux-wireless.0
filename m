Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:60959 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S966571Ab2ERCAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 22:00:22 -0400
Message-ID: <4FB5ADAB.5010206@Magitekindustries.com> (sfid-20120518_040026_642397_D19560E5)
Date: Thu, 17 May 2012 22:02:19 -0400
From: DC <DC@Magitekindustries.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel 2200BG/Linux
References: <6x75xpmamff1htgn6m1n6t9l.1337272291919@email.android.com> <CAGRGNgVnHwFH99xDn_OG93OerJRK8QzYacm-JwhxXjdmwCC2UA@mail.gmail.com>
In-Reply-To: <CAGRGNgVnHwFH99xDn_OG93OerJRK8QzYacm-JwhxXjdmwCC2UA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Didn't know it was a party line. On it.

I haven't been able to get the driver to load. The download on the site
doesn't work.

The firmware should be installed on the card, because the card runs
perfectly on the windows side of the drive, but if it needs to be
installed on Linux, then no, it's likely not.

But again, the page has no download link.



On 5/17/12 7:46 PM, Julian Calaby wrote:
> Hi,
>
> Firstly, always Reply-All, that way other people on the list will see
> your emails, and may be able to help if I can't.
>
> On Fri, May 18, 2012 at 2:31 AM, D <dc@magitekindustries.com> wrote:
>> I'm not having any luck with this. The os is bt5 which it's a build of Ubuntu
> Ok, so can you confirm that the ipw2200 driver is actually loaded. You
> can do this using the lsmod command.
>
> Are there any errors or warnings in the kernel log (see the output from dmesg)
>
> Have you installed the firmware?
>
> Thanks,
>
> Julian Calaby
>
>> Julian Calaby <julian.calaby@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> On Sun, May 6, 2012 at 3:33 PM, DC <DC@magitekindustries.com> wrote:
>>>>    I'm having the hardest time in the world getting this card to work
>>>> with Linux. Can you help me?
>>> You need to use the ipw2200 driver, and you need the firmware.
>>>
>>> The driver should already be in your distro's kernel, and the firmware
>>> should be available through it's package repository.
>>>
>>> E.g. in Debian, the firmware is available in the firmware-ipw2x00 package.
>>>
>>> Thanks,
>>>
>>> --
>>> Julian Calaby
>>>
>>> Email: julian.calaby@gmail.com
>>> Profile: http://www.google.com/profiles/julian.calaby/
>>> .Plan: http://sites.google.com/site/juliancalaby/
>
>

