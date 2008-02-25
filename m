Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:36748 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756971AbYBYRmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 12:42:20 -0500
From: Chr <chunkeey@web.de>
To: Florian Fainelli <florian.fainelli@telecomint.eu>
Subject: Re: p54usb with Inventel UR054g dongle
Date: Mon, 25 Feb 2008 18:41:49 +0100
Cc: linux-wireless@vger.kernel.org
References: <200802251731.22264.florian.fainelli@telecomint.eu>
In-Reply-To: <200802251731.22264.florian.fainelli@telecomint.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200802251841.49431.chunkeey@web.de> (sfid-20080225_174243_819774_701865C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 February 2008 17:31:21 Florian Fainelli wrote:
> Hi all,
>
> I am testing an Inventel UR054g dongle with p54usb, and some fields cannot
> be parsed :
>
> p54: LM86 firmware
> p54: FW rev 2.5.8.0 - Softmac protocol 3.0
> code = 100
> data = ecd96a24
> code = 6700
> data = ecd96a26
> code = 1300
> data = ecd96c28
> p54: not all required entries found in eeprom!
> p54: eeprom parse failed!
> prism54usb: Invalid hwaddr! Using randomly generated MAC addr
>
> I have added some printks here to show the code it fails to decode and the
> associated eeprom entry.
>
> Do you have any hints about what these particular codes mean ?

Please, could you make a "dump" of the eeprom? Because these "code" values
are invalid...

> Thank you very much in advance.

Thanks,
	Chr.
