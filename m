Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:35267 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab0BSQND convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Feb 2010 11:13:03 -0500
Received: by ewy28 with SMTP id 28so278359ewy.28
        for <linux-wireless@vger.kernel.org>; Fri, 19 Feb 2010 08:13:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100215193042.GA10665@tuxdriver.com>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <201002100002.11369.mb@bu3sch.de>
	 <20100215193042.GA10665@tuxdriver.com>
Date: Fri, 19 Feb 2010 17:12:59 +0100
Message-ID: <b170af451002190812m9209a1cja236c199da9a019a@mail.gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/15 John W. Linville <linville@tuxdriver.com>:
> On Wed, Feb 10, 2010 at 12:02:11AM +0100, Michael Buesch wrote:
>> On Tuesday 09 February 2010 21:04:33 Rafał Miłecki wrote:
>> > +#define B43_MMIO_PSM_PHY_HDR               0x492   /* programmable state machine */
>>
>> The comment doesn't make a lot of sense.
>> In case you don't know, the PSM is the part of the hardware
>> that executes the firmware.
>
> Rafał,
>
> Are you going to repost this series and/or respond to Michael's
> comments?  I tried to apply some of the ones Michael didn't comment
> upon, but they seem to depend on the ones in question.

I got some exams recently and today I got one more for recrucation for
new studies level. Will fix patches this week.

-- 
Rafał
