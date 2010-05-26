Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:8196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab0EZWVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 18:21:47 -0400
Received: by fg-out-1718.google.com with SMTP id e12so1049594fga.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 15:21:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1274911569.2593.8.camel@mj>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj> <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	<1268190973.10669.12.camel@mj> <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
	<1274911569.2593.8.camel@mj>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Thu, 27 May 2010 00:21:26 +0200
Message-ID: <AANLkTin6cAHj2p266yMLQkrpkhCdX98leNl5F8f3DAJR@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
To: Pavel Roskin <proski@gnu.org>
Cc: Paul Thomas <pthomas8589@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 27, 2010 at 12:06 AM, Pavel Roskin <proski@gnu.org> wrote:
> On Mon, 2010-03-29 at 15:19 -0700, Paul Thomas wrote:
>> OK, I'd love to get to where Pavel & Gabor are, but I think I'm having
>> trouble with the PCI dependency. I'm on an arm platform without PCI
>> (atmel at91sam9g20). If I remove the PCI dependency from the Kconfig
>> it does compile with warnings, and then when the module loads I get
>> "r8192s_usb: Unknown symbol wireless_send_event".
>>
>> I'm happy to hang out and try again when the driver leaves staging,
>> but I thought I might mention the PCI dependency now.
>
> wireless_send_event should be available if WIRELESS_EXT is selected in Kconfig.
>
> But I cannot find the "r8192s_usb" symbol in any staging drivers, so I
> have no idea which driver you are talking about.

r8192s_usb is not a symbol, it is the name of the module being loaded.

>
> I suggest that you don't hijack existing threads to report new issues.
> When reporting a problem, please give the kernel version, the driver
> name and whatever details are needed for others to reproduce the
> problem.
>
>> > CCMP is working, and I could browse the web over it!
>
> Please don't quote parts of the message that are irrelevant to what you
> are saying.
>
> --
> Regards,
> Pavel Roskin
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
