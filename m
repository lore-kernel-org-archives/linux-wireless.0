Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36378 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab2BADNV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 22:13:21 -0500
Received: by iacb35 with SMTP id b35so829854iac.19
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jan 2012 19:13:21 -0800 (PST)
Message-ID: <4F28ADCD.80300@lwfinger.net> (sfid-20120201_041347_243965_31F7B0AD)
Date: Tue, 31 Jan 2012 21:13:17 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Prashant Badsheshi <prashant.badsheshi@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Regarding carl9170 wifi linux driver
References: <CA+cdTWaGcDasoAQc8h7hdexpfwp4dtu-3EqcPNGp4b-UK9xgrw@mail.gmail.com>
In-Reply-To: <CA+cdTWaGcDasoAQc8h7hdexpfwp4dtu-3EqcPNGp4b-UK9xgrw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2012 08:18 PM, Prashant Badsheshi wrote:
> Hi,
>
> We are planning to use the below wifi dongle as station and AP.
>
> https://www.thinkpenguin.com/gnu-linux/penguin-wireless-n-usb-adapter
>
>
>
> We got the linux driver from the below path
>
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
>
>
>
> We found the driver source in drivers/net/wireless/ath/carl9170.
>
>
>
> Our Question:
>
> Is the carl9170 driver present in the above folder is a complete open
> source driver?
>
> Or is it not complete driver and is there any NON-GPL code that is not
> provided as an open source?
>
> Please clarify it. Your immediate response would be really appreciated.
>
>
>
> Also it would be great if there is any design document or programmer’s
> document for the above mentioned Wifi dongle chipset available.

EVERYTHING in the Linux kernel in any one of the official trees, including 
wireless-testing, is licensed under GPL.

Larry

