Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:25781 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbZDEWuz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Apr 2009 18:50:55 -0400
Received: by fg-out-1718.google.com with SMTP id 16so166027fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 05 Apr 2009 15:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <8db1092f0904050211m3385bf45wbf1a0452cb44cc06@mail.gmail.com>
References: <8db1092f0904050211m3385bf45wbf1a0452cb44cc06@mail.gmail.com>
Date: Sun, 5 Apr 2009 23:50:52 +0100
Message-ID: <3ace41890904051550l216aa6cdjfbcf3a0e22526b99@mail.gmail.com> (sfid-20090406_005058_699173_CA188B22)
Subject: Re: [2.6.29-git12 iwl3945] wlan0: beacon loss from AP
	00:19:5b:e7:a2:f8 - sending probe request
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 5, 2009 at 10:11 AM, Maciej Rutecki
<maciej.rutecki@gmail.com> wrote:
> Wireless card:
> 08:00.0 Network controller: Intel Corporation PRO/Wireless 3945ABG
> [Golan] Network Connection (rev 02)
>
> I have compiled 2.6.29-git12. Comparing to 2.6.29 (stable) I have
> message in dmesg:
>
> wlan0: beacon loss from AP 00:19:5b:e7:a2:f8 - sending probe request
>
> Also iwconfig shows slow Bit Rate (1 Mb/s). Connection seems be
> stable, but it never happen in 2.6.29.
>
> Dmesg:
> http://unixy.pl/maciek/download/kernel/2.6.29-git12/dmesg-2.6.29-git12.txt
>
> Dmesg (after "echo 0x43fff > /sys/class/net/wlan0/device/debug_level"):
> http://unixy.pl/maciek/download/kernel/2.6.29-git12/dmesg-2.6.29-git12-debug.txt
>
>
> iwconfig wlan0 from 2.6.29 (I remove "Encryption key"):
> http://unixy.pl/maciek/download/kernel/2.6.29-git12/iwconfig_wlan0_2.6.29.txt
>
> iwconfig wlan0 from 2.6.29-git12:
> http://unixy.pl/maciek/download/kernel/2.6.29-git12/iwconfig_wlan0_2.6.29-git12.txt
>
> Config (2.6.29-git12):
> http://unixy.pl/maciek/download/kernel/2.6.29-git12/config-2.6.29-git12.txt

Hmm, you probably need to distinguish what your real problem is, and
what you think
the problem is. I have a few
"wlan2: beacon loss from AP <mac_address> - sending probe request" in
my dmesg since I upgraded
lately, but my wireless connectivity is fine. I think that message is
just the occasional informative/debug messages
that the kernel dev people add, just to be informative (and I am using
a different driver/hardware altogether).
