Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:21284 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933541Ab0BQAo7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 19:44:59 -0500
Received: by ey-out-2122.google.com with SMTP id d26so1633062eyd.19
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2010 16:44:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100214131810.1a8b49ac@houba>
References: <4B38A298.7070103@googlemail.com>
	 <1262037590.16627.99.camel@localhost.localdomain>
	 <3ace41890912310638x4387f73bvc7ba5e00d096ead7@mail.gmail.com>
	 <20100213234456.5ae49b67@houba> <20100214004010.GB18815@tuxdriver.com>
	 <20100214131810.1a8b49ac@houba>
Date: Wed, 17 Feb 2010 00:44:56 +0000
Message-ID: <3ace41891002161644g7d09c598td86381680c3f04f8@mail.gmail.com>
Subject: Re: staging: No option to select rtl8192su in linux-2.6.33-rc2
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Frederic Leroy <fredo@starox.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Chris Mayo <aklhfex@googlemail.com>,
	linux-wireless@vger.kernel.org, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 14, 2010 at 12:18 PM, Frederic Leroy <fredo@starox.org> wrote:
> Le Sat, 13 Feb 2010 19:40:10 -0500,
> "John W. Linville" <linville@tuxdriver.com> a écrit :
>
>> [...]
>> > Should I follow the TODO file from Greg in staging :
>> > ( which seems to merge : rtl8192e  rtl8192su  rtl8192u )
>> > [...]
>> This is a reasonable plan overall, although I might quibble with
>> the order.
>>
>> > Or use rtl818x tree to start a new device ?
>>
>> YMMV, but given the code I've seen for the Realtek drivers in staging
>> I might be inclined to start by forking rtl8180 and making the
>> necessary hardware changes from there.
>
> It was my impression too, but as you say, YMMV. It will be my first
> driver, although I already hacked the kernel, make netfilters modules
> and read lwn ;).
>
> For the process, it is still unclear for me. I copy rtl8180*[ch] to
> rtl8192*[ch], and start to hack into to make clean git patches ?
>
> On which tree should I base my work :
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git ?

It is probably useful to pull from
git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
as well - I think wireless-testing's log may be more granular
