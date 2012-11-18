Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:47120 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab2KRMrP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2012 07:47:15 -0500
Message-ID: <50A8D8C9.1000802@hauke-m.de> (sfid-20121118_134724_781753_21302DEA)
Date: Sun, 18 Nov 2012 13:47:05 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: ralf@linux-mips.org, john@phrozen.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, florian@openwrt.org
Subject: Re: [PATCH v4 0/3] MIPS: BCM47xx: use gpiolib
References: <1347376511-20953-1-git-send-email-hauke@hauke-m.de> <CACna6rw0Qy2=zo6wHcq20JBM8OJb-wnZJGLH3dksaLGFoyp+=w@mail.gmail.com>
In-Reply-To: <CACna6rw0Qy2=zo6wHcq20JBM8OJb-wnZJGLH3dksaLGFoyp+=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2012 12:05 PM, Rafał Miłecki wrote:
> 2012/9/11 Hauke Mehrtens <hauke@hauke-m.de>:
>> The original code implemented the GPIO interface itself and this caused
>> some problems. With this patch gpiolib is used.
>>
>> This is based on mips/master.
>>
>> This should go through linux-mips, John W. Linville approved that
>> for the bcma and ssb changes normally maintained in wireless-testing.
> 
> Ping? Did it go upstream? I can't find that commits in
> http://git.kernel.org/?p=linux/kernel/git/ralf/linux.git;a=summary
> 
I talked to John Crispin in IRC, he does not like this patch and I will
send a new version today.

Hauke
