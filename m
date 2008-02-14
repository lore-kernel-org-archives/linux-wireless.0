Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.186]:23632 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbYBNQts (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 11:49:48 -0500
Received: by ti-out-0910.google.com with SMTP id 28so389333tif.23
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2008 08:49:46 -0800 (PST)
Message-ID: <c9d168940802140849v3f7ea53ajf23279ec3efd126@mail.gmail.com> (sfid-20080214_164952_426648_4EB7D5A4)
Date: Thu, 14 Feb 2008 08:49:44 -0800
From: Ramesh <rramesh1@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Wi-Fi interface intermittently missing on HP laptop
Cc: "Broadcom Linux" <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <47B46E36.3050206@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47B46E36.3050206@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry.

I have a HP DV6040US & I do see the same problem. Initiallly, when I
hit this problem a year back, it was figured out to be a mother board
issue and HP fixed it by replacing the motherboard. I am seeing the
same problem for the past 10 days. The mini pci doesnt get detected,
for every 10 reboots it gets detected once-in-a-while.  It looks like
chronic condition with HP Laptops & my laptop went out of warranty & I
luckily had it extended, not sure if this is a bcm chipset issue or
HP's motherboard problem, planning to put a USB Wireless adapter to
fix this problem.

Cheers
/Ramesh

On Thu, Feb 14, 2008 at 8:37 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> The BCM94311 interface on my HP dv2125nr is intermittent. Twice (so far) it has gone missing and
>  will not show up when the PCI subsystem is interrogated using lspci. It is hardware because Windows
>  doesn't find it either.
>
>  I remember seeing reports of this problem on mailing lists. If your computer has suffered from this
>  error, please let me know what it took to fix it. I suspect a motherboard problem, and would like to
>  know other's experiences when I try to get mine fixed under warranty.
>
>  Thanks,
>
>  Larry
>
>
>  -
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
