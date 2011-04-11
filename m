Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52181 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754795Ab1DKVTP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 17:19:15 -0400
MIME-Version: 1.0
In-Reply-To: <20110411210631.GA28559@kroah.com>
References: <1302557114-7880-1-git-send-email-zajec5@gmail.com>
	<20110411210631.GA28559@kroah.com>
Date: Mon, 11 Apr 2011 23:19:13 +0200
Message-ID: <BANLkTim155YxMUVJ=pmVs-rNhkovGPG6OQ@mail.gmail.com>
Subject: Re: [RFC][PATCH V3] axi: add AXI bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	George Kashperko <george@znau.edu.ua>,
	Arnd Bergmann <arnd@arndb.de>,
	Russell King <rmk@arm.linux.org.uk>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	b43-dev@lists.infradead.org,
	=?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
	linuxdriverproject <devel@linuxdriverproject.org>,
	Andy Botting <andy@andybotting.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/11 Greg KH <greg@kroah.com>:
> On Mon, Apr 11, 2011 at 11:25:14PM +0200, Rafał Miłecki wrote:
>> +static void axi_release_core_dev(struct device *dev)
>> +{
>> +     /* Silent lack-of-release warning */
>> +}
>
> Ok, WTF!!!!

Thank you for your kindly words. It's much more enjoyable to work on
kernel that way. I definitely made that on purpose.

-- 
Rafał
