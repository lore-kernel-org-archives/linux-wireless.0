Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753333AbcGVLzj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2016 07:55:39 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@codeaurora.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	netdev@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Mateusz Kulikowski <mateusz.kulikowski@gmail.com>,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	Andrea Merello <andrea.merello@gmail.com>
Subject: Re: [PATCH 2/3] staging/rtl8192e: use s8 instead of char
References: <20160719153403.2967812-1-arnd@arndb.de>
	<3876342.AU5AfU16PB@wuerfel> <wrfjk2ggpbmw.fsf@redhat.com>
	<8046944.AyQGVaNKWH@wuerfel> <20160722043922.0a878698@mir>
Date: Fri, 22 Jul 2016 07:55:36 -0400
In-Reply-To: <20160722043922.0a878698@mir> (Stefan Lippers-Hollmann's message
	of "Fri, 22 Jul 2016 04:39:22 +0200")
Message-ID: <wrfjoa5phop3.fsf@redhat.com> (sfid-20160722_135612_148901_DA2BD760)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefan Lippers-Hollmann <s.l-h@gmx.de> writes:
> Hi
>
> On 2016-07-20, Arnd Bergmann wrote:
>> On Wednesday, July 20, 2016 11:33:43 AM CEST Jes Sorensen wrote:
>> > Arnd Bergmann <arnd@arndb.de> writes:  
>> > > On Wednesday, July 20, 2016 7:25:19 AM CEST Jes Sorensen wrote:  
>> > >> Arnd Bergmann <arnd@arndb.de> writes:
> [...]
>> Yes, I was just agreeing here that it's not worth doing that one.
>> As far as I can see, the evolution of these devices is
>> 
>> RTL81xxU (2008)
>> RTL81xxSU (2009)
>> RTL81xxCU (2010)
>
> There is also RTL81xxDU, apparently from 2011, a dualband device
> coming in several variants (single MAC + single PHY, double MAC +
> double PHY and double PHY); e.g. 0bda:8194 (single PHY + single MAC).
>
> While probably not overly common, it was/ is (hardware-wise) a pretty
> interesting device due to its support for 5 GHz[1] - actually I hoped
> it to be a (supported-) RTL8192CU variant when I bought it. 
> Unfortunately no driver[2] made it to staging or the proper kernel.

I actually have one of those in my USB dongle box, but as you say, not
overly common so not sure if/when I'll get to it.

Adding 8192du support for 2.4GHz to rtl8xxxu probably wouldn't be too
complicated.

Cheers,
Jes
