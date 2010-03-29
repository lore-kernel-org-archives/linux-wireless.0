Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43530 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab0C2WTr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 18:19:47 -0400
Received: by pwi5 with SMTP id 5so7107895pwi.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 15:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1268190973.10669.12.camel@mj>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	 <1268190973.10669.12.camel@mj>
Date: Mon, 29 Mar 2010 15:19:46 -0700
Message-ID: <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
From: Paul Thomas <pthomas8589@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, I'd love to get to where Pavel & Gabor are, but I think I'm having
trouble with the PCI dependency. I'm on an arm platform without PCI
(atmel at91sam9g20). If I remove the PCI dependency from the Kconfig
it does compile with warnings, and then when the module loads I get
"r8192s_usb: Unknown symbol wireless_send_event".

I'm happy to hang out and try again when the driver leaves staging,
but I thought I might mention the PCI dependency now.

thanks,
Paul

2010/3/9 Pavel Roskin <proski@gnu.org>:
> On Sun, 2010-03-07 at 16:36 +0100, Gábor Stefanik wrote:
>
>> Maybe with an actual RTL8192SU firmware it would work... just my 2 HUF.
>
> Actually, you are absolutely right!  The driver is working fine with the
> firmware from rtl8192su_linux_2.6.0002.0708.2009.tar.gz
>
> CCMP is working, and I could browse the web over it!
>
> --
> Regards,
> Pavel Roskin
>
