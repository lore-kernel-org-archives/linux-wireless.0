Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:44226 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3AVLZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2013 06:25:11 -0500
Received: by mail-wg0-f50.google.com with SMTP id es5so303635wgb.29
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2013 03:25:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2A8023D6-2F21-465E-BE46-0CD260E3EC1A@gmail.com>
References: <2A8023D6-2F21-465E-BE46-0CD260E3EC1A@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 22 Jan 2013 22:24:48 +1100
Message-ID: <CAGRGNgVGFd2vazDqngZasrxy3FBhgpYXQxg3Jb-jZGgK6EanjQ@mail.gmail.com> (sfid-20130122_122519_498161_4AC6828E)
Subject: Re: Install
To: Raenan Guadez <raenanguadez@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Raenan,

You seem to be new here, so just a couple of pointers. Firstly make
sure you Reply All, and CC linux-wireless when replying. Secondly,
most of us are volunteers and do support in our spare time, so don't
expect a prompt reply. Also, please don't top post - if I replied only
with this paragraph, I'd be top posting, my response, below your
quoted message is bottom posting and is the best way to format your
emails for mailing lists like this one.

On Tue, Jan 22, 2013 at 7:00 PM, Raenan Guadez <raenanguadez@gmail.com> wrote:
> I'm confused on how to configure the card in terminal to work? Is there a clear step by step command line prompt to follow?

What exactly are you trying to do?

Firstly, I have to ask the standard questions:
1. Which distribution are you using and what version?
2. What kernel version are you using?
3. Are you using compat-wireless and if so, what version?
4. What type of card are you trying to use? Running "lspci" or "lsusb"
should help identify it.
5. Have you installed the firmware for it? (If applicable)
6. Is it detected by the kernel? i.e. if you run "dmesg", are there
lines referencing the card?

But back to your questions.

Are you using a graphical user interface, e.g. Gnome, Unity or KDE? If
so, you should install Network Manager or wicd as this will take care
of configuring your wireless card and do it in a nice user-friendly
manner.

If you don't, then the simplest way is to use wpa_supplicant to manage
the wireless card. Your distribution should provide a manual with it
(try running "man wpa_supplicant") which will describe how to
configure it.

Please let us know how you go.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
