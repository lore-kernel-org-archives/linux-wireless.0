Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:64276 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965569Ab0B0LMZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 06:12:25 -0500
Received: by ewy20 with SMTP id 20so499499ewy.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 03:12:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201002100002.11369.mb@bu3sch.de>
References: <1265745883-3392-2-git-send-email-zajec5@gmail.com>
	 <201002100002.11369.mb@bu3sch.de>
Date: Sat, 27 Feb 2010 12:12:23 +0100
Message-ID: <b170af451002270312y304b9c81mc6223a6e28608f3a@mail.gmail.com>
Subject: Re: [PATCH 01/11] b43: N-PHY: add some registers and structs
	definitions
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/2/10 Michael Buesch <mb@bu3sch.de>:
> On Tuesday 09 February 2010 21:04:33 Rafał Miłecki wrote:
>> +#define B43_MMIO_PSM_PHY_HDR         0x492   /* programmable state machine */
>
> The comment doesn't make a lot of sense.
> In case you don't know, the PSM is the part of the hardware
> that executes the firmware.

Well, guess you're right. It was me hearing for the first time "PSM"
so decided to write it. Guess it's pretty obvious for every device
driver developer :)

-- 
Rafał
