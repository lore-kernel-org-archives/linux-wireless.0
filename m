Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65473 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932883Ab1DMVdI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Apr 2011 17:33:08 -0400
MIME-Version: 1.0
In-Reply-To: <1302729850.8479.7.camel@dev.znau.edu.ua>
References: <1302634375-2378-1-git-send-email-zajec5@gmail.com>
	<20110413163113.GA24015@kroah.com>
	<BANLkTin-4HrJzNrLOxRy_-a98S3ZF4aSQw@mail.gmail.com>
	<1302726703.8015.1.camel@dev.znau.edu.ua>
	<BANLkTimwZOJ0a5kVfaUzEcsMc39H999u0A@mail.gmail.com>
	<1302727516.8015.9.camel@dev.znau.edu.ua>
	<BANLkTi=wzzzeF-PmqLt9o8arW7nRaFRRJw@mail.gmail.com>
	<1302729243.8479.1.camel@dev.znau.edu.ua>
	<BANLkTinLn4Ug=gX4coHJbSzrkxdSMjgGeg@mail.gmail.com>
	<1302729850.8479.7.camel@dev.znau.edu.ua>
Date: Wed, 13 Apr 2011 23:33:07 +0200
Message-ID: <BANLkTimsuGy0kRoP2xmApof=j-WnPYse9w@mail.gmail.com>
Subject: Re: [RFC][PATCH V4] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Greg KH <greg@kroah.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Arend van Spriel <arend@broadcom.com>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Botting <andy@andybotting.com>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/13 George Kashperko <george@znau.edu.ua>:
>> 2011/4/13 George Kashperko <george@znau.edu.ua>:
>> >> I had no idea what you were referring to. We do not dig into PCIe
>> >> functions yet, so I believe for now we need this "if".
>> > You are already deep inside. Your host code drives pci function.
>>
>> But I don't use multiple PCIe functions, do not focus on that at all.
>>
> Don't see anything in the host driver code preventing it to be bound to
> functions other than 0. But anyways if you sure your host will be used
> by several cores then why don't you spinlock window accesses ?

I should, it was discussed, please let's leave it for now.

Lets first focus on how to correctly implement this driver.

-- 
Rafał
