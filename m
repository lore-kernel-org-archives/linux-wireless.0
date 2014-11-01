Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:52380 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbaKAJvP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2014 05:51:15 -0400
Received: by mail-ig0-f175.google.com with SMTP id h3so2305125igd.8
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2014 02:51:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1414804501.1032.1.camel@gmail.com>
References: <1414804501.1032.1.camel@gmail.com>
Date: Sat, 1 Nov 2014 10:51:15 +0100
Message-ID: <CACna6ry7HZeDt4w-a_Se9Y4ecLJU==pROLWMYSSPNGWY=XgPZw@mail.gmail.com> (sfid-20141101_105120_169801_37F37FE4)
Subject: Re: BCM43228 wireless card broken in kernel update [b43]
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Duncan de Wet <duncandewet@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 November 2014 02:15, Duncan de Wet <duncandewet@gmail.com> wrote:
> After the kernel update to 3.17.1-1-ARCH, I can view a list of wireless
> networks but not connect to any. Both GNOME network manager and wicd-gtk
> say "Connecting..." then without an error message change to "Not
> Connected".
>
> (...)
>
> Thank you for any help.

So what I suggest you is to re-do all tests with a *proper*
(un)installing drivers and/or blacklisting them.

There is no point in tracking b43 regression as there can't be one.
There weren't any bcma/b43 changes between 3.17 and 3.17.1.

I suggest you to check if Broadcom's wl can work with your BCM43228
and 3.17.1. Make sure (I mean *sure*) you use *only* wl.ko. Then try
to connect. This will let us know if there is anything wrong about
cfg80211.

-- 
Rafał
