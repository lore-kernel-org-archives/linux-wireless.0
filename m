Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:59801 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935666Ab1ETMH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:07:58 -0400
Received: by mail-ew0-f45.google.com with SMTP id 24so1343450ewy.32
        for <linux-wireless@vger.kernel.org>; Fri, 20 May 2011 05:07:57 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove unused crc7 references
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305707056-4503-1-git-send-email-eliad@wizery.com>
References: <1305707056-4503-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:07:53 +0300
Message-ID: <1305893273.12586.1672.camel@cumari> (sfid-20110520_140801_623375_CD9F494C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-18 at 11:24 +0300, Eliad Peller wrote:
> crc7 is used only in wl12xx_spi.
> 
> Remove redundant crc7.h includes, and update Kconfig to select CRC7
> only if WL12XX_SPI is being selected.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks! It's good to get rid of some unnecessary dependencies.

-- 
Cheers,
Luca.

