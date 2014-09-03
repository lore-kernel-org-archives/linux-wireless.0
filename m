Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:44685 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbaICTsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:48:43 -0400
Message-ID: <54077098.5070303@hauke-m.de> (sfid-20140903_214846_913325_7449A193)
Date: Wed, 03 Sep 2014 21:48:40 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] bcma: move bus struct setup into early part of host
 specific code
References: <1409605867-30051-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1409605867-30051-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/01/2014 11:11 PM, Rafał Miłecki wrote:
> This change is important for SoC host. In future we will want to know
> chip ID (needed for early MIPS boot) before doing cores scanning.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/host_pci.c   | 3 +++
>  drivers/bcma/host_soc.c   | 3 +++
>  drivers/bcma/main.c       | 2 --
>  drivers/bcma/scan.c       | 7 -------
>  include/linux/bcma/bcma.h | 1 -
>  5 files changed, 6 insertions(+), 10 deletions(-)
> 

