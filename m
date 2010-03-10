Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:54329 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753969Ab0CJB75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 20:59:57 -0500
Subject: Re: Realtek rtl8188 support?
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Paul Thomas <pthomas8589@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 20:59:55 -0500
Message-Id: <1268186395.3410.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-07 at 16:36 +0100, Gábor Stefanik wrote:
> 2010/3/7 Pavel Roskin <proski@gnu.org>:
> > I was able to load the driver, bring the interface up and scan.  I could
> > not connect to an AP with CCMP for some reason:
> >
> > # wpa_supplicant -c /etc/wpa_supplicant/mike1.conf -i wlan29 -D wext
> > ioctl[SIOCSIWPMKSA]: Invalid argument
> > ioctl[SIOCSIWPMKSA]: Invalid argument
> > CTRL-EVENT-SCAN-RESULTS
> > CTRL-EVENT-SCAN-RESULTS
> > Trying to associate with 00:25:9c:28:15:62 (SSID='mike1' freq=2437 MHz)
> > ioctl[SIOCSIWFREQ]: Operation not supported
> > Association request to the driver failed
> 
> Maybe with an actual RTL8192SU firmware it would work... just my 2 HUF.

I brushed up my firmware extraction skills and extracted the firmware
from the latest Windows driver for rtl8188su.

Unfortunately, the results are exactly the same.  Scanning works, but
wpa_supplicant fails in the same way.

OK, at least I won't be able to blame the firmware from now on.

-- 
Regards,
Pavel Roskin
