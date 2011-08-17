Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:36362 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753421Ab1HQOFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 10:05:12 -0400
Received: by mail-pz0-f47.google.com with SMTP id 2so1601250pzk.34
        for <linux-wireless@vger.kernel.org>; Wed, 17 Aug 2011 07:05:10 -0700 (PDT)
Subject: Re: [PATCH v3 02/40] wl12xx: Use a single fw for both STA and AP
 roles
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1313567149-26475-1-git-send-email-eliad@wizery.com>
References: <1313567149-26475-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Aug 2011 07:05:08 -0700
Message-ID: <1313589908.2920.3.camel@cambuci> (sfid-20110817_160516_263865_9E8AF977)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-08-17 at 10:45 +0300, Eliad Peller wrote:
> From: Arik Nemtsov <arik@wizery.com>
> 
> Firmware >= 6/7.3.0.0.75 (wl127x/wl128x) supports both
> STA and AP roles.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---
> v3: s/WL1271/WL127X in spi.c

Ah, nice that you fixed this.  I had actually seen this problem (I
always compile the SPI module) and I had already fixed it in my tree.

-- 
Cheers,
Luca.

