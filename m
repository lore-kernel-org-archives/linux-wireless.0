Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42383 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaAWGPo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:15:44 -0500
Received: by mail-wi0-f170.google.com with SMTP id ex4so262449wid.5
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 22:15:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
References: <52DF947E.40800@gmail.com> <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 23 Jan 2014 11:45:22 +0530
Message-ID: <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com> (sfid-20140123_071547_325135_7DC8A6F1)
Subject: Re: 802.11a is supported in AP mode or not?
To: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
Cc: zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 23, 2014 at 7:30 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> Thanks for your mail, but very pity, after checking, it doesn't as well. May you test it on your board?
>
>
> # iw reg get
> country US:
>         (2402 - 2472 @ 40), (30, 0)
>         (5170 - 5250 @ 80), (17, 0)
>         (5250 - 5330 @ 80), (23, 0)
>         (5735 - 5835 @ 80), (30, 0)
>         (57240 - 63720 @ 2160), (40, 0)
>
> country_code=US
> hw_mode=a
> channel=149
>
> #hostapd -B /etc/hostapd.conf
> Configuration file: /etc/hostapd.conf
> channel [19] (149) is disabled for use in AP mode, flags: 0x7
> wlan0: IEEE 802.11 Configured channel (149) not found from the channel list of current mode (2) IEEE 802.11a
> wlan0: IEEE 802.11 Hardware does not support configured channel
> Could not select hw_mode and channel. (-4)
> wlan0: Unable to setup interface.
> rmdir[ctrl_interface]: No such file or directory
>
Can you use "hostapd -dd -B /etc/hostapd.conf"and send the output?
Also "hostapd -v" and "iw phy" as well.
