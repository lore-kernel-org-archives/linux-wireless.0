Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47098 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1DJLco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 07:32:44 -0400
MIME-Version: 1.0
In-Reply-To: <op.vtpt6v173ri7v4@arend-laptop>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<20110410080159.GB2798@ucw.cz>
	<BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
	<20110410082420.GA1460@localhost.ucw.cz>
	<BANLkTim9JTpZGib+_C_vTFFhP5azbGwMjg@mail.gmail.com>
	<op.vtpt6v173ri7v4@arend-laptop>
Date: Sun, 10 Apr 2011 13:32:43 +0200
Message-ID: <BANLkTimgJ--19=q-od7S8uj6T6AcXrtg7w@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael B?sch" <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Russell King <rmk@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 10 kwietnia 2011 11:33 użytkownik Arend van Spriel
<arend@broadcom.com> napisał:
> On Sun, 10 Apr 2011 10:30:53 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:
>
>> 2011/4/10 Pavel Machek <pavel@ucw.cz>:
>>>>
>>>> >> >+config BCMAI_HOST_PCI_POSSIBLE
>>>> >> >+       bool
>>>> >> >+       depends on BCMAI && PCI = y
>>>> >> >+       default y
>>>> >> >+
>>>> >> >+config BCMAI_HOST_PCI
>>>> >> >+       bool "Support for AI on PCI-host bus"
>>>> >> >+       depends on BCMAI_HOST_PCI_POSSIBLE
>>>> >> >+
>
> Hi Rafał,
>
> Could use term AMBA AXI instead which gives enough hits on Google to hint
> interested people to more in depth information.
>
> FYI: AXI = Advanced eXtensible Interface
>        High-speed interconnect for chip cores ( provides higher
> bursts/transfers than predecessor AHB = Advanced High-performance Bus
> (AHB)).

"If you check PATCH V2, we renamed this to (AMBA) AXI"

-- 
Rafał
