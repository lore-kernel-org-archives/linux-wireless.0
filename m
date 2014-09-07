Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:48589 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752386AbaIGT2c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 15:28:32 -0400
Message-ID: <540CB1DE.8090008@hauke-m.de> (sfid-20140907_212835_171982_1F6EA16D)
Date: Sun, 07 Sep 2014 21:28:30 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/2] bcma: register NAND and QSPI cores early
References: <1409869129-15674-1-git-send-email-zajec5@gmail.com> <1409869129-15674-2-git-send-email-zajec5@gmail.com>
In-Reply-To: <1409869129-15674-2-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2014 12:18 AM, Rafał Miłecki wrote:
> On Northstar (ARM arch) we will use MTD subsystem to access NVRAM and
> SPROM. To get access to flash device we need to register these cores
> first.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/main.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 

