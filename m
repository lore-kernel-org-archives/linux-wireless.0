Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:65315 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbZEYVOP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 17:14:15 -0400
Received: by fxm12 with SMTP id 12so1603014fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 25 May 2009 14:14:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A1B00E7.5070801@gmx.net>
References: <4A199FED.7000609@gmx.net>
	 <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
	 <4A1B00E7.5070801@gmx.net>
Date: Mon, 25 May 2009 22:14:15 +0100
Message-ID: <3ace41890905251414v75544ed4o7bafdb3cdc170d1d@mail.gmail.com>
Subject: Re: RTL 8185
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Barkle <barkle@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 25, 2009 at 9:34 PM, Barkle <barkle@gmx.net> wrote:

> Have a look in the appended file "dmesg_2009-05-25.txt" and it's not wlan0,
> it's phy0.
> I hope, I haven't cut off too much .

You have removed almost everything that might be useful... e.g. it is
not possible to tell even if you have a 32-bit CPU or a 64-bit CPU for
sure (although it *looks* like a 64-bit system), dual core/SMP or
single CPU, and what else is on your PCI bus. Is that really
necessary??? Very few people are telepathic, you know... at least I
don't know of any.

> There is no more reaktion, no change by pressing num-lock, caps-lock or
> scroll-lock. No answer on a ping. What I didn't tested is the "magic SysRq".

And any last minute syslog, etc in your log files after you power-cycle?


> wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf -W
> -dd

If you are not using any encryption (WEP/WPA, etc), there is no need
to run wpa_supplicant. Also, what's in /var/log/wpa_supplicant.log ?
In fact you should shutdown network manager and wpa_suplicant and
probably dbus as well.


> No entry in the syslog

Again you have edited away your CPU type, and, since you are trying to
see what's wrong with your wireless device, you really should disable
dhcp against your wired networking interface.

> OK, no I didn't tried the compat-wireless so far..
> It will take a while, when I got an result of the change.

Please gIve compat-wireless a go.

You have edited away any useful info in your dmesg and syslog, so
there is nothing to tell. Why did you do that?
