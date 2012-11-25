Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37625 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab2KYM1z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 07:27:55 -0500
Message-ID: <50B20EBB.3080204@hauke-m.de> (sfid-20121125_132759_022831_CE2B3C39)
Date: Sun, 25 Nov 2012 13:27:39 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Sergei Shtylyov <sshtylyov@mvista.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	wim@iguana.be, linux-watchdog@vger.kernel.org,
	castet.matthieu@free.fr, biblbroks@sezampro.rs, m@bues.ch,
	zajec5@gmail.com, linux-mips@linux-mips.org
Subject: Re: [PATCH 04/15] watchdog: bcm47xx_wdt.c: rename wdt_timeout to
 timeout
References: <1353795855-22236-1-git-send-email-hauke@hauke-m.de> <1353795855-22236-5-git-send-email-hauke@hauke-m.de> <50B14BD6.8050302@mvista.com>
In-Reply-To: <50B14BD6.8050302@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2012 11:36 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 25-11-2012 2:24, Hauke Mehrtens wrote:
> 
>> Rename rename
> 
>    Once it enough. :-)
> 
>> wdt_timeout
> 
>    'wdt_time', you mean?
> 
>> to timeout to name it like the other watchdog
>> driver do it.
> 
>    It's not the only change you're doing.
> 
Thanks for spotting this, I will change the changelog.

Hauke
