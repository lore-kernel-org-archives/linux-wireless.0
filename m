Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sd-11162.dedibox.fr ([88.191.70.230]:43773 "EHLO
	sd-11162.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758294Ab0BNMTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 07:19:00 -0500
Date: Sun, 14 Feb 2010 13:18:10 +0100
From: Frederic Leroy <fredo@starox.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hin-Tak Leung <hintak.leung@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
Message-ID: <20100214131810.1a8b49ac@houba>
In-Reply-To: <20100214004010.GB18815@tuxdriver.com>
References: <4B38A298.7070103@googlemail.com>
	<1262037590.16627.99.camel@localhost.localdomain>
	<3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>
	<20100213234456.5ae49b67@houba>
	<20100214004010.GB18815@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le Sat, 13 Feb 2010 19:40:10 -0500,
"John W. Linville" <linville@tuxdriver.com> a écrit :

> [...]
> > Should I follow the TODO file from Greg in staging :
> > ( which seems to merge : rtl8192e  rtl8192su  rtl8192u )
> > [...] 
> This is a reasonable plan overall, although I might quibble with
> the order.
>
> > Or use rtl818x tree to start a new device ?
> 
> YMMV, but given the code I've seen for the Realtek drivers in staging
> I might be inclined to start by forking rtl8180 and making the
> necessary hardware changes from there.
 
It was my impression too, but as you say, YMMV. It will be my first
driver, although I already hacked the kernel, make netfilters modules
and read lwn ;).

For the process, it is still unclear for me. I copy rtl8180*[ch] to
rtl8192*[ch], and start to hack into to make clean git patches ?

On which tree should I base my work : 
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git ?

> hth!

It helps :)

-- 
Frédéric Leroy
