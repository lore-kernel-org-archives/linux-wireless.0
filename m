Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:54325 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267Ab3AWWSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 17:18:47 -0500
Received: by mail-wi0-f181.google.com with SMTP id hq4so1186555wib.2
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jan 2013 14:18:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAOctcr9+k_9FBJ=bdbYmxEcrHkk8ihYAV20H+qtSmtk7Yv0f+w@mail.gmail.com>
References: <2A8023D6-2F21-465E-BE46-0CD260E3EC1A@gmail.com>
 <CAGRGNgVGFd2vazDqngZasrxy3FBhgpYXQxg3Jb-jZGgK6EanjQ@mail.gmail.com> <CAOctcr9+k_9FBJ=bdbYmxEcrHkk8ihYAV20H+qtSmtk7Yv0f+w@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 24 Jan 2013 09:18:24 +1100
Message-ID: <CAGRGNgUvk=85op1M4c+RaEY7o__xpTo1k7XmOCoEvMsMr8gmYQ@mail.gmail.com> (sfid-20130123_231910_556322_D734A709)
Subject: Re: Install
To: raenan guadez <raenanguadez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raenan,

I also forgot to mention: HTML emails are not accepted by the list, so
despite you CCing linux-wireless, it was only received by me.

On Wed, Jan 23, 2013 at 5:27 PM, raenan guadez <raenanguadez@gmail.com> wrote:
> Hi Julian,
>
> Yes I am new to linux.  Thank you for letting me know the structure for the
> emails.  I appreciate the help and do understand its volunteer.
>
> Firstly, I have to ask the standard questions:
> 1. Which distribution are you using and what version?
> I am using Ubuntu Desktop 12.04 LTS

Good, I'm somewhat familiar with that distro.

> 2. What kernel version are you using?
> 3.2.0 - 36 generic pae
>
> 3. Are you using compat-wireless and if so, what version?
> not sure, how do i find out?

If you don't know then you're probably not. It's not an issue.

> 4. What type of card are you trying to use? Running "lspci" or "lsusb"
> should help identify it.
> Intel Pro/Wireless 3945 ABG card

Ok, the driver for those is fairly stable.

> 5. Have you installed the firmware for it? (If applicable)
> I do not believe the firmware is installed because when I go under Network
> it says the firmware is missing for the wireless device.

Then you _need_ to install the firmware. This is in the
firmware-iwlwifi package.

> 6. Is it detected by the kernel? i.e. if you run "dmesg", are there
> lines referencing the card?
> Yes it detects the card

Good.

I note that you are using Network Manager. Once the firmware is
installed, Network Manager will detect the card and configure it for
you.

If you're still desperate to connect to a wireless network from the
command line, then the simplest way is to use wpa_supplicant to manage
the wireless card. Note that you will have to _completely_ disable
Network Manager for it to work. Your distribution should provide a
manual with it (try running "man wpa_supplicant") which will describe
how to configure it.

Note that in Network Manager, if you change a connection to be
"available to all users" Network Manager will connect to it on startup
before you log in. Also, network connections aren't restricted to a
particular user or just the GUI or anything like that - once it's
connected, everyone on the computer can use it.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
