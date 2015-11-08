Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38784 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997AbbKHNxI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 08:53:08 -0500
MIME-Version: 1.0
In-Reply-To: <20151107205101.GK18797@mwanda>
References: <1446895909-30052-1-git-send-email-punitvara@gmail.com>
	<20151107135427.GH18797@mwanda>
	<CABXAfNJWe78txO91YixoEZTO1n7q69LqN89UpDanrT8cA-jnyA@mail.gmail.com>
	<20151107205101.GK18797@mwanda>
Date: Sun, 8 Nov 2015 19:23:07 +0530
Message-ID: <CABXAfNJciCnr2nLFuxFBb7yGXVJgB+mw0O2VN4EidEgGV4eUFQ@mail.gmail.com> (sfid-20151108_145312_964275_1239FB99)
Subject: Re: [PATCH] Staging: wilc1000: Fix build break due to undeclared
 *wilc and implicit declaration of init_irq
From: punit vara <punitvara@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
	chris.park@atmel.com, Austin Shin <austin.shin@atmel.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	johnny.kim@atmel.com, tony.cho@atmel.com, leo.kim@atmel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2015 at 2:21 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> I haven't looked at it, sorry.  You'll have to figure it out or if you
> complain to the original person who broken the build he can figure it
> out.  You are still missing a Fixes tag.
>
> regards,
> dan carpenter
Here I will remove struct wilc *wilc;
and add
#if (defined WILC_SPI) || (!defined WILC_SDIO)

I have used git tag -l in my git tree and found v4.3-rc7 ..That is the
tag I have to include in this patch description right ?
