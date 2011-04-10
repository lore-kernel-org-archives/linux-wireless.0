Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:57412 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1DJIFr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 04:05:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110410080159.GB2798@ucw.cz>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<20110410080159.GB2798@ucw.cz>
Date: Sun, 10 Apr 2011 10:05:46 +0200
Message-ID: <BANLkTikL+GvaKN6nT-9WjpPjaJz0dR51KQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arend van Spriel <arend@broadcom.com>,
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

2011/4/10 Pavel Machek <pavel@ucw.cz>:
> Hi!
>
>
>> >@@ -0,0 +1,30 @@
>> >+config BCMAI_POSSIBLE
>> >+       bool
>> >+       depends on HAS_IOMEM && HAS_DMA
>> >+       default y
>> >+
>> >+menu "Broadcom's AI"
>> >+       depends on BCMAI_POSSIBLE
>> >+
>> >+config BCMAI
>> >+       tristate "AI support"
>> >+       depends on BCMAI_POSSIBLE
>> >+
>> >+config BCMAI_HOST_PCI_POSSIBLE
>> >+       bool
>> >+       depends on BCMAI && PCI = y
>> >+       default y
>> >+
>> >+config BCMAI_HOST_PCI
>> >+       bool "Support for AI on PCI-host bus"
>> >+       depends on BCMAI_HOST_PCI_POSSIBLE
>> >+
>> >+config BCMAI_DEBUG
>> >+       bool "BCMAI debugging"
>> >+       depends on BCMAI
>> >+       help
>> >+         This turns on additional debugging messages.
>> >+
>> >+         If unsure, say N
>
> Totally useless  :-(. It should really explain what AI means in this context.

Feel free to propose sth.

-- 
Rafał
