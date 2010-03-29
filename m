Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45248 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0C2XcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 19:32:25 -0400
Received: by fxm23 with SMTP id 23so1306658fxm.21
        for <linux-wireless@vger.kernel.org>; Mon, 29 Mar 2010 16:32:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	<69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	<1267949782.15192.13.camel@mj> <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
	<1268190973.10669.12.camel@mj> <c785bba31003291519tfd7d26fy466a4ee4310ac590@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 30 Mar 2010 01:32:03 +0200
Message-ID: <69e28c911003291632h44ecc3cfld5fba8d0a4abfc4@mail.gmail.com>
Subject: Re: Realtek rtl8188 support?
To: Paul Thomas <pthomas8589@gmail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	Andrea Merello <andreamrl@tiscali.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 12:19 AM, Paul Thomas <pthomas8589@gmail.com> wrote:
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

wireless_send_event is in wext_core - try adding a dependency on WEXT_CORE.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
