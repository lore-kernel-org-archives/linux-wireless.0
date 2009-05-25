Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:65189 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbZEYGPg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 02:15:36 -0400
Received: by fxm12 with SMTP id 12so1091609fxm.37
        for <linux-wireless@vger.kernel.org>; Sun, 24 May 2009 23:15:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A199FED.7000609@gmx.net>
References: <4A199FED.7000609@gmx.net>
Date: Mon, 25 May 2009 07:15:37 +0100
Message-ID: <3ace41890905242315i53dbb93dsf98e7a3a574a3c29@mail.gmail.com>
Subject: Re: RTL 8185
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Barkle <barkle@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 24, 2009 at 8:28 PM, Barkle <barkle@gmx.net> wrote:
> Hi,
>
> I have a pci-card with a RTL8185 chip.
> [01:07.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8185 IEEE
> 802.11a/b/g Wireless LAN Controller (rev 20)]
>
> Base on a Debian Lenny with
> kernel 2.6.30-rc5
> wpasupplicant v0.6.9
> wireless_tools 30
>
> I can change some parameter on the card with iwconfig, for example the
> channel, but every time I try to get the card to work, the kernel freeze.
>
> Now I´m not sure, if this mailinglist is the right one, because it may be a
> problem of the hardware, the kernel or some userland tools.
>
> If you need any additional information, please ask me an I try to answer
> asap.

Yes, this is the right list - a few things:
1) dmesg should show a few line of info, including a line like this:

wlan0: hwaddr XX:XX:XX:XX;XX:XX <chip_name> + <rf_type>

we need at least that line, and anything else that's relevant in dmesg.

2) what do you mean by 'kernel freeze'? e.g. if you do it without X,
do you get a pile of
cryptic messages before lock up (if that's the case)? If there is, try
to take a picture of it with a digital camera;
if you computer is still operational, please cut-and-paste that to the reply.

Also, describe what exactly did you try to do, step by step.

3) have you tried compat-wireless? compat-wireless is ahead of
2.6.30-rcX and occasionally have fixes to bugs which creeps into the
rc's...
