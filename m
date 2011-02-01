Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50426 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1BAM3h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 07:29:37 -0500
Received: by qwa26 with SMTP id 26so6628608qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 04:29:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110201114757.GA11930@sig21.net>
References: <AANLkTik=oRjh9UHAsOOTpuOJR7OBw2HCsXd8vhHN_YJY@mail.gmail.com>
	<20110201114757.GA11930@sig21.net>
Date: Tue, 1 Feb 2011 12:29:35 +0000
Message-ID: <AANLkTikd9v8SOsVH8ez3T7qpan9z400=4a4q08hwhQWo@mail.gmail.com>
Subject: Re: Ralink RT2501/RT2573 USB Wireless Adapter crashes kernel 2.6.37
From: Eric Fernandez <zeb@zebulon.org.uk>
To: Johannes Stezenbach <js@sig21.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/2/1 Johannes Stezenbach <js@sig21.net>:

> I have no immediate idea about the cause of the crash, but
> did you make sure you unloaded _all_ wireless modules
> before plugging in the USB adapter after installing
> compat-wireless?  "make unload" or a reboot should do the trick.
>
> If it still crashes, can you check dmesg for the crash messages?
>
>
> Thanks,
> Johannes
>

Hi Johannes,

This happend on reboot, yes. I rebooted without the adapter plugged
in, then I left udev load the modules upon plugging the USB adapter.
I'll send you the error message in a few hours when I am back home.
Note that when the system freezes (the original bug, with the modules
from kernel 2.6.37), I get no log messages whatsoever.

Thanks,
Eric
