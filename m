Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49068 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab2GQTKS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 15:10:18 -0400
Message-ID: <5005B893.1090302@hauke-m.de> (sfid-20120717_211021_726156_1D67CDE8)
Date: Tue, 17 Jul 2012 21:10:11 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] bcma: add place for flash memory support
References: <1342535201-19621-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1342535201-19621-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This looks good to me.

On 07/17/2012 04:26 PM, Rafał Miłecki wrote:
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> Hope my recent patches will make OpenWrt guys mainline their work ;)
This is mostly because of lack of time to do that. OpenWrt has running
code for parallel and serial flash access, but it needs some more clean
ups, mostly the partition parsing code. If you want to mainline it I
have no problem with that.
> ---
>  drivers/bcma/Kconfig                    |   10 ++++++++++
>  drivers/bcma/Makefile                   |    2 ++
>  drivers/bcma/bcma_private.h             |   22 ++++++++++++++++++++++
>  drivers/bcma/driver_chipcommon_nflash.c |   19 +++++++++++++++++++
>  drivers/bcma/driver_chipcommon_sflash.c |   19 +++++++++++++++++++
>  drivers/bcma/driver_mips.c              |   15 ++++++++++++---
>  6 files changed, 84 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/bcma/driver_chipcommon_nflash.c
>  create mode 100644 drivers/bcma/driver_chipcommon_sflash.c
