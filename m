Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43257 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1EEXBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 May 2011 19:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=epFN2EZBj9n8pac6h7F4RWmyk+Q@mail.gmail.com>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<BANLkTi=epFN2EZBj9n8pac6h7F4RWmyk+Q@mail.gmail.com>
Date: Fri, 6 May 2011 01:01:48 +0200
Message-ID: <BANLkTi=fmTBs=kOwRQWROHWzAG7h_0T80w@mail.gmail.com> (sfid-20110506_010206_789004_95D7C2DC)
Subject: Re: [PATCH][WAS:bcmai,axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, Greg KH <greg@kroah.com>,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
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

W dniu 6 maja 2011 00:59 użytkownik Julian Calaby
<julian.calaby@gmail.com> napisał:
> Rafał,
>
> A minor nit:
>
> On Fri, May 6, 2011 at 07:59, Rafał Miłecki <zajec5@gmail.com> wrote:
>> diff --git a/Documentation/ABI/testing/sysfs-bus-bcma b/Documentation/ABI/testing/sysfs-bus-bcma
>> new file mode 100644
>> index 0000000..ad3cd69
>> --- /dev/null
>> +++ b/Documentation/ABI/testing/sysfs-bus-bcma
>> @@ -0,0 +1,31 @@
>> +What:          /sys/bus/bcma/devices/.../class
>> +Date:          May 2011
>> +KernelVersion: 2.6.40
>> +Contact:       Rafał Miłecki <zajec5@gmail.com>
>> +Description:
>> +               Each AXI core is identified by few fields, including class it
>> +               belongs to. See include/linux/bcma/bcma.h for possible values.
>
> Should this not read BCMA or something similar, not AXI?
>
> Ditto for the rest of the changes to this file.

Ups, I left old name in this single place. Thx.

-- 
Rafał
