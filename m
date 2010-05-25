Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0EYAQR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 20:16:17 -0400
Received: by fxm5 with SMTP id 5so2757159fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 17:16:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	 <1268190973.10669.12.camel@mj>
	 <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
Date: Mon, 24 May 2010 17:16:15 -0700
Message-ID: <AANLkTinUyRtemRZAN_IS7IqE033GPyKFe77FC94TcTYu@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
From: Paul Thomas <pthomas8589@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>,
	Jerry chuang <wlanfae@realtek.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 29, 2010 at 3:19 PM, Paul Thomas <pthomas8589@gmail.com> wrote:
> OK, I'd love to get to where Pavel & Gabor are, but I think I'm having
> trouble with the PCI dependency. I'm on an arm platform without PCI
> (atmel at91sam9g20). If I remove the PCI dependency from the Kconfig
> it does compile with warnings, and then when the module loads I get
> "r8192s_usb: Unknown symbol wireless_send_event".
>
> I'm happy to hang out and try again when the driver leaves staging,
> but I thought I might mention the PCI dependency now.
>
> thanks,
> Paul

I haven't seen any activity on this driver in awhile. Is anyone
working on it? My main request is to remove the PCI dependency. Any
chance of this?

Or does anyone else know of a "mini" wireless adapters with a
supported chipset (i.e. without needing PCI)? Both devices I've
ordered from newegg ended up having the rtl8188 chip.

thanks,
Paul
