Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:59613 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3LKU1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Dec 2013 15:27:42 -0500
Message-ID: <1386793658.23883.29.camel@porter.coelho.fi> (sfid-20131211_212747_711302_2F2901E0)
Subject: Re: Doc for Qualcomm AR3001 HCI
From: Luca Coelho <luca@coelho.fi>
To: Frank Zhao <frank.zhao.main@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 11 Dec 2013 22:27:38 +0200
In-Reply-To: <CAGGtaNarW2fVT=KyCgYpCrZv914FQR26kQNza0VvKR2FBZrnMQ@mail.gmail.com>
References: <CAGGtaNarW2fVT=KyCgYpCrZv914FQR26kQNza0VvKR2FBZrnMQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-12-11 at 15:03 -0500, Frank Zhao wrote:
> Hi
> 
> I am doing some hacking on a PlayStation 4's DualShock 4 controller,
> inside is a Qualcomm Atheros AR3002 connected to a microcontroller
> using UART HCI. I have a logic analyzer connected to the UART signals
> and I have captured a lot of data. But a lot of the HCI commands have
> OGF of 0xFC which means that the commands are "vendor defined", and
> thus they are not in the HCI functional specifications documentation.
> 
> I can't find any helpful technical documentation at all from
> Qualcomm's website and they probably won't help some hobbyist anyways.
> I've searched Google and found your website. You guys have written a
> driver for this chip already, so you must have some documentation on
> Qualcomm's own HCI commands. Can you please share this documentation
> with me?

You're probably looking at a Bluetooth chip.  You have a better chance
of getting answers if you try linux-bluetooth@vger.kernel.org.

But proprietary commands are usually, well, proprietary and closed, not
public.  So I guess you may have some difficulties there.  You most
likely need to reverse-engineer it yourself. ;)

--
Luca.

