Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:35767 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaDTOkV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 10:40:21 -0400
Received: by mail-ob0-f180.google.com with SMTP id wm4so3359301obc.25
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 07:40:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEnUK=Pd7TwhABQLgX8zqhJBwh57ZE90AUXq+PCT4j7-sE2AKg@mail.gmail.com>
References: <CAEnUK=Oi6FL48o_L-Ax6U=qVNWg8YbXRYTa_G1sJGj_H0HvCMg@mail.gmail.com>
	<CAEnUK=MSX1uj0JYdOKj-FyM944=_PXMRmxZSLrfmW3y=QyoWKQ@mail.gmail.com>
	<CAEnUK=Pd7TwhABQLgX8zqhJBwh57ZE90AUXq+PCT4j7-sE2AKg@mail.gmail.com>
Date: Sun, 20 Apr 2014 16:40:20 +0200
Message-ID: <CABikg9xyB5_Lhzadax-PdHw_1WPGqPYdASYxVgtxDw+GXzhJbA@mail.gmail.com> (sfid-20140420_164035_251971_1C0AF555)
Subject: Re: RTL8192CU chip strange works
From: Sergei Antonov <saproj@gmail.com>
To: =?UTF-8?B?0JDRgNGC0LXQvCDQodC10YDQs9C40LXQvdC60L4=?=
	<imtaurin@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 April 2014 17:47, Артем Сергиенко <imtaurin@gmail.com> wrote:
> Hello! I bought a device TP-Link wn8200nd with Realtek RTL8192CU chip.
>
> I have troubles to connect it to the my Asus RT-N16 under Linux (Gentoo).
>
> It connecting to WiFi spot in my phones. But it can't connect to Asus
> RT-N16 in Linux. It connects to Asus RT-N16 only under Windows.
> I used drivers from various Linux kernels and used drivers from your
> official site, but there is no success. I absolutely can't understand
> what's happening. Why in Linux I can connect to some devices but I
> can't connect to my home router. (Router works fine for 3 years)
> Every time connection asks me a password, I enter it, but in minute or
> less it wants me to enter password one more time. (I even change
> password to very easy, password is right)
>
> I read a lot off information about it, and I know many people which
> have similar problems.
>
> Please help me. I think all troubles in the driver. I can send you all
> information that you need.

Some possibly useful information:
1. wpa_supplicant's verbose logs. On my computer it is normally
started with -B to run in background, and when I want to investigate
an issue I run it without -B and with -dd to get a verbose log in the
console.
2. What version of rtlwifi firmware is loaded? Look it up in dmesg.
Other relevant strings from dmesg may be helpful too.
