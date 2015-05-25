Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f41.google.com ([209.85.215.41]:35008 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759AbbEYLdv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2015 07:33:51 -0400
Received: by labbd9 with SMTP id bd9so47789957lab.2
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2015 04:33:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55605637.1080503@gmail.com>
References: <55605637.1080503@gmail.com>
Date: Mon, 25 May 2015 14:33:49 +0300
Message-ID: <CANUX_P0OzQ45pChQxc-9WVK=7_qh6M4CcE28U6pnu5RbH-qNuQ@mail.gmail.com> (sfid-20150525_133357_283770_169624DF)
Subject: Re: packet loss, disconnects and possible bug in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Nick Dimov <dimovnike@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 23, 2015 at 1:28 PM, Nick Dimov <dimovnike@gmail.com> wrote:
> Hello,
> I recently bought the Intel 7260 AC wifi card (below is the PCI info)
> and the card works perfectly in windows with the latest intel driver but
> in linux I get deauthenticating and disconnects (reason -3) every minute
> or so. When these disconnects happen I get packet loss. In the attached
> file iwlwifi_dmesg.txt you can see the log that is produced each time a
> disconnect happens. I also tried connecting on 2.4Ghz but I get the same
> packet loss. I also put the last firmware from
> http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git
> but it did not help.

Please increase the debug level of the supplicant. And attach the full syslog.

>
> There is also another problem: In windows i can see it connecting on
> 860mbps, but on linux it never goes higher than 600mbps (i check this
> with iwconfig) and it stays somewhere on 500mbps.
>
> Can you please help me solve this?
> Thank you.
>
> uname -a
> Linux nick-laptop 3.19.0-18-generic #18-Ubuntu SMP Tue May 19 18:31:35
> UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>
> lspci info:
> 03:00.0 Network controller: Intel Corporation Wireless 7260 (rev bb)
>         Subsystem: Intel Corporation Dual Band Wireless-AC 7260
>         Flags: bus master, fast devsel, latency 0, IRQ 29
>         Memory at f7200000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [40] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Device Serial Number d8-fc-93-ff-ff-e4-70-d7
>         Capabilities: [14c] Latency Tolerance Reporting
>         Capabilities: [154] Vendor Specific Information: ID=cafe Rev=1
> Len=014 <?>
>         Kernel driver in use: iwlwifi
>
