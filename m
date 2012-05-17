Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:37197 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709Ab2EQXqX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 19:46:23 -0400
Received: by lbbgm6 with SMTP id gm6so1683544lbb.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 16:46:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6x75xpmamff1htgn6m1n6t9l.1337272291919@email.android.com>
References: <6x75xpmamff1htgn6m1n6t9l.1337272291919@email.android.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 May 2012 09:46:01 +1000
Message-ID: <CAGRGNgVnHwFH99xDn_OG93OerJRK8QzYacm-JwhxXjdmwCC2UA@mail.gmail.com> (sfid-20120518_014708_194836_D2C38658)
Subject: Re: Intel 2200BG/Linux
To: D <dc@magitekindustries.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Firstly, always Reply-All, that way other people on the list will see
your emails, and may be able to help if I can't.

On Fri, May 18, 2012 at 2:31 AM, D <dc@magitekindustries.com> wrote:
> I'm not having any luck with this. The os is bt5 which it's a build of Ubuntu

Ok, so can you confirm that the ipw2200 driver is actually loaded. You
can do this using the lsmod command.

Are there any errors or warnings in the kernel log (see the output from dmesg)

Have you installed the firmware?

Thanks,

Julian Calaby

> Julian Calaby <julian.calaby@gmail.com> wrote:
>
>>Hi,
>>
>>On Sun, May 6, 2012 at 3:33 PM, DC <DC@magitekindustries.com> wrote:
>>>    I'm having the hardest time in the world getting this card to work
>>> with Linux. Can you help me?
>>
>>You need to use the ipw2200 driver, and you need the firmware.
>>
>>The driver should already be in your distro's kernel, and the firmware
>>should be available through it's package repository.
>>
>>E.g. in Debian, the firmware is available in the firmware-ipw2x00 package.
>>
>>Thanks,
>>
>>--
>>Julian Calaby
>>
>>Email: julian.calaby@gmail.com
>>Profile: http://www.google.com/profiles/julian.calaby/
>>.Plan: http://sites.google.com/site/juliancalaby/



-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
