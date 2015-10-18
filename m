Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34857 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663AbbJRJ3M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 05:29:12 -0400
Subject: Re: [PATCH] staging: wilc1000: restore wilc_spi_dev variable
To: Arnd Bergmann <arnd@arndb.de>, gregkh@linuxfoundation.org
References: <4978401.AVrDN2jmbq@wuerfel>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
From: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Message-ID: <5623665F.40700@gmail.com> (sfid-20151018_113004_077125_5577C2D2)
Date: Sun, 18 Oct 2015 12:29:03 +0300
MIME-Version: 1.0
In-Reply-To: <4978401.AVrDN2jmbq@wuerfel>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

On 16.10.2015 23:05, Arnd Bergmann wrote:
> A recent change to wilc1000 accidentally deleted an important
> variable, so we now get a build error when the SPI mode is
> selected:
> 
> ERROR: "wilc_spi_dev" [drivers/staging/wilc1000/wilc1000.ko] undefined!
> 
> This partially reverts the broken commit to put the variable back.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Fixes: 56293ff232b9 ("staging: wilc1000: linux_wlan_spi: include header")
> ---

I'm really sorry about it, will be more careful in the future. 

Thank you for fixing this.
