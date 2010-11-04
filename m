Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:35338 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab0KDTdd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 15:33:33 -0400
Received: by qwf7 with SMTP id 7so1598360qwf.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 12:33:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CD2C8F4.5000309@lwfinger.net>
References: <4CD2B6E9.9080303@lwfinger.net>
	<1288878640.10023.2.camel@Nokia-N900-51-1>
	<4CD2C8F4.5000309@lwfinger.net>
Date: Thu, 4 Nov 2010 20:33:32 +0100
Message-ID: <AANLkTikqsZyyOWcODScuo63a+B60QvkWO=f39cS8j4Ey@mail.gmail.com>
Subject: Re: Question about wireless configuration
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/11/4 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/04/2010 08:50 AM, Johannes Berg wrote:
>>> I am trying to test the latest Realtek driver for the RTL8187L. In order
>>> for the driver to be able to scan, CONFIG_WIRELESS_EXT must be set to
>>> "y". I could find no way to do that with the kernel configuration
>>> utilities until I made the following patch. I know it is wrong, but I
>>> would like to know the correct way.
>>
>> There is no correct way, drivers that need it will select it in kconfig which obviously doesn't work for out-of-tree drivers.
>
> Thanks. I selected ZD1201 in the configuration, and WIRELESS_EXT is there.

Done the same for wl :) I think I just used ipw2200 driver, not ZD1201.

-- 
Rafał
