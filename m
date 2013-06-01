Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33564 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326Ab3FASGv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 14:06:51 -0400
Message-ID: <51AA3832.2070605@hauke-m.de> (sfid-20130601_200657_584923_E6208459)
Date: Sat, 01 Jun 2013 20:06:42 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Marc_Mar=ED?= <5.markmb.5@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Intel Centrino Advanced N 6200 and Debian 7
References: <CA+nFU8T5Ja9jg_E7=Y4TbsT+OxJfNy=x18CMm3VUA9BcKb1+WA@mail.gmail.com>
In-Reply-To: <CA+nFU8T5Ja9jg_E7=Y4TbsT+OxJfNy=x18CMm3VUA9BcKb1+WA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/01/2013 07:57 PM, Marc Marí wrote:
> Hello everyone
> 
> I recently changed my wireless card from a Broadcom (very bad
> supported) to a Intel Centrino Advanced N 6200. In Fedora, it works
> well, but I prefer Debian, and I'll change again, but in a Debian 7
> live CD (I need my laptop, so I can't stay several days with a half
> installation) the wifi doesn't work (kernel 3.2.0-4). This is the
> error
> 
> Jun  1 17:36:54 localhost kernel: [ 1355.505261] iwlwifi 0000:03:00.0:
> Unsupported (too old) EEPROM VER=0x416 < 0x423 CALIB=0x5 < 0x4

This looks like you bought an engineering sample and not a device that
should be sold to end users. This device is not supported and you
probably have to buy a different one.

> Jun  1 17:36:54 localhost kernel: [ 1355.505393] iwlwifi: probe of
> 0000:03:00.0 failed with error -22
> 
> Searching the web, it seems that the error is not very common, but is
> a weird thing, so I am asking for any support in this.
> 
> Thank you in advance
> Marc

