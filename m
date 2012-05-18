Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33143 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030626Ab2ERCcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 22:32:39 -0400
Received: by lahd3 with SMTP id d3so1766284lah.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 19:32:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FB5ADAB.5010206@Magitekindustries.com>
References: <6x75xpmamff1htgn6m1n6t9l.1337272291919@email.android.com>
 <CAGRGNgVnHwFH99xDn_OG93OerJRK8QzYacm-JwhxXjdmwCC2UA@mail.gmail.com> <4FB5ADAB.5010206@Magitekindustries.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 18 May 2012 12:32:17 +1000
Message-ID: <CAGRGNgUc=bi9vOfukw_uBRH7TD=wYcFJ1yEPVLiFfAw8cK_-9g@mail.gmail.com> (sfid-20120518_043243_005451_403119D9)
Subject: Re: Intel 2200BG/Linux
To: DC <DC@magitekindustries.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, May 18, 2012 at 12:02 PM, DC <DC@magitekindustries.com> wrote:
> I haven't been able to get the driver to load. The download on the site
> doesn't work.

Where are you downloading it from.

The driver should already be installed in BackTrack 5.

Could you please check the output of the lsmod command to see if the
driver has been loaded?

Then check the kernel logs using the dmesg command to see if there are
any messages or errors about this driver. If the firmware is not
available, it will complain about this in the kernel log.

Without that information, we can't really help you.

> The firmware should be installed on the card, because the card runs
> perfectly on the windows side of the drive, but if it needs to be
> installed on Linux, then no, it's likely not.

The firmware for a device is generally built into windows drivers, and
is always separate from the kernel part of Linux drivers. It is very
rare that firmware is actually built into computer components, even if
they need it.

I would be surprised if BackTrack doesn't have a package called
"firmware-ipw2x00" or something similar that contains the firmware.
Install that package with a package manager or the software center and
the firmware will be installed in the correct place to be loaded by
the driver.

> But again, the page has no download link.

Which page?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
