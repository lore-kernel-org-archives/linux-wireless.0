Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2114 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755164Ab1DJJeO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 05:34:14 -0400
To: "Pavel Machek" <pavel@ucw.cz>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Michael B?sch" <mb@bu3sch.de>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"George Kashperko" <george@znau.edu.ua>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"Russell King" <rmk@arm.linux.org.uk>,
	"Arnd Bergmann" <arnd@arndb.de>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
 <op.vtisojsk3ri7v4@arend-laptop> <20110410080159.GB2798@ucw.cz>
 <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
 <20110410082420.GA1460@localhost.ucw.cz>
 <BANLkTim9JTpZGib+_C_vTFFhP5azbGwMjg@mail.gmail.com>
Date: Sun, 10 Apr 2011 11:33:57 +0200
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vtpt6v173ri7v4@arend-laptop>
In-Reply-To: <BANLkTim9JTpZGib+_C_vTFFhP5azbGwMjg@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 10 Apr 2011 10:30:53 +0200, Rafał Miłecki <zajec5@gmail.com> wrote:

> 2011/4/10 Pavel Machek <pavel@ucw.cz>:
>>> >> >+config BCMAI_HOST_PCI_POSSIBLE
>>> >> >+       bool
>>> >> >+       depends on BCMAI && PCI = y
>>> >> >+       default y
>>> >> >+
>>> >> >+config BCMAI_HOST_PCI
>>> >> >+       bool "Support for AI on PCI-host bus"
>>> >> >+       depends on BCMAI_HOST_PCI_POSSIBLE
>>> >> >+

Hi Rafał,

Could use term AMBA AXI instead which gives enough hits on Google to hint  
interested people to more in depth information.

FYI: AXI = Advanced eXtensible Interface
	High-speed interconnect for chip cores ( provides higher bursts/transfers  
than predecessor AHB = Advanced High-performance Bus (AHB)).

Gr. AvS
-- 
"The world is indeed comic, but the joke is on mankind." — H.P. Lovecraft

