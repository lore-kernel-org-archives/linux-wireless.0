Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50196 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab3LSM1u (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 07:27:50 -0500
Message-ID: <52B2E638.8060906@hauke-m.de> (sfid-20131219_132801_317708_8F172CF7)
Date: Thu, 19 Dec 2013 13:27:36 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Naughtboy <skylvlinux@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bcm43236 complient in the compat-wireless-3.6.81???
References: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>
In-Reply-To: <CAKH5=Lv=7CroQcx6x_JONnE+6mOTH1sLLcSxntGq2fogn-t4+Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/19/2013 11:03 AM, Naughtboy wrote:
> hi erveryone !
> i  have a usb dongle bcm43236
> i wan to trsan it in the mips bcm47xx
> but i search in hte www , and didn't find the driver for bcm43236
> linux soucre code !!
> i have find and study  http://wireless.kernel.org/en/users/Drivers/b43
> 
> and  find   http://wireless.kernel.org/en/users/Drivers/b43 do nothing
> usefull !!
> 
> anyone can do one hand?
> thanks advance !!
> 
> -----Naughyboy !

Hi,

I assume you have a bcm43236 rev 2 as all the bcm43236s connected to a
MIPS BCM47XX SoC I saw have that rev.  There is probably no open source
driver for the bcm43236 rev 2, just rev 3 is supported by brcmfmac.

Hauke
