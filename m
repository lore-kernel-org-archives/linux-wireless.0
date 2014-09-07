Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hauke-m.de ([5.39.93.123]:48583 "EHLO hauke-m.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752010AbaIGTZ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2014 15:25:29 -0400
Message-ID: <540CB124.1080406@hauke-m.de> (sfid-20140907_212534_520688_5D498A1C)
Date: Sun, 07 Sep 2014 21:25:24 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 1/2] bcma: move code for core registration into separate
 function
References: <1409869129-15674-1-git-send-email-zajec5@gmail.com>
In-Reply-To: <1409869129-15674-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2014 12:18 AM, Rafał Miłecki wrote:
> This cleans code a bit and will us to register cores in other places as
> well. The only difference with this patch is using "core_index" for
> setting device name.
> 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Hauke Mehrtens <hauke@hauke-m.de>

> ---
>  drivers/bcma/main.c | 67 ++++++++++++++++++++++++++++-------------------------
>  1 file changed, 36 insertions(+), 31 deletions(-)
> 

