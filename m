Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:57312 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab1BITOx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 14:14:53 -0500
Message-ID: <4D52E7A7.6060402@hauke-m.de>
Date: Wed, 09 Feb 2011 20:14:47 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] compat-wireless: fix some problems with brcm80211
References: <1297200981-22971-1-git-send-email-hauke@hauke-m.de> <AANLkTinM-uZ_R8nJhzUosmneX6KhjmUk+Cc0XQ+W3k2_@mail.gmail.com>
In-Reply-To: <AANLkTinM-uZ_R8nJhzUosmneX6KhjmUk+Cc0XQ+W3k2_@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2011 11:34 PM, Rafał Miłecki wrote:
> 2011/2/8 Hauke Mehrtens <hauke@hauke-m.de>:
>> We have to activate debug, without we get compile errors
> 
> And spam users with all messages? What about fixing errors?
> 
Hi,

I already send a patch to the brcm80211 guys [1]. so we hopefully do not
need debugging for a long time. In the normal kernel build this
debugging was activated by default till some days ago, so for the users
nothing changes. ;-)

Hauke

 [1]
http://driverdev.linuxdriverproject.org/pipermail/devel/2011-February/011879.html
