Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:42429 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756426Ab3FGPnS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jun 2013 11:43:18 -0400
Message-ID: <51B1FF88.2070104@hauke-m.de> (sfid-20130607_174335_410700_962BE866)
Date: Fri, 07 Jun 2013 17:43:04 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: George Nychis <gnychis@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: trying to build backports, "input in flex scanner failed"
References: <CA+7oygfDcFYaE+=n_5Vygk5SuwwMCtF2SCeeeW-c3dx16E1Uyw@mail.gmail.com>
In-Reply-To: <CA+7oygfDcFYaE+=n_5Vygk5SuwwMCtF2SCeeeW-c3dx16E1Uyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/07/2013 05:14 PM, George Nychis wrote:
> Hi all,
> 
> I am trying to build backports-3.10-rc1-2 on an Ubuntu 12.04 LTS.
> Whenever I try to start a clean build, I get the error:
> 
> gnychis@parallels:/media/psf/Documents/thesis/backports-3.10-rc1-2$
> make defconfig-rt2x00
> cc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
> -fomit-frame-pointer   -c -o conf.o conf.c
> cc -Wall -Wmissing-prototypes -Wstrict-prototypes -O2
> -fomit-frame-pointer   -c -o zconf.tab.o zconf.tab.c
> cc   conf.o zconf.tab.o   -o conf
> input in flex scanner failed
> make[1]: *** [defconfig-rt2x00] Error 2
> make: *** [defconfig-rt2x00] Error 2
> 
> I have flex installed.  It's not getting very far.  Does anyone know
> what the issue could be here?

The package does not contain a rt2x00 default config, have you generated
one by yourself? Does this problem also occur when your run make
menuconfig or make defconfig-rtlwifi?

Hauke
