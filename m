Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:38533 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754664Ab1LAOXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Dec 2011 09:23:54 -0500
Received: by mail-lpp01m010-f41.google.com with SMTP id i5so1045923lah.14
        for <linux-wireless@vger.kernel.org>; Thu, 01 Dec 2011 06:23:47 -0800 (PST)
Subject: Re: [PATCH 0/2] wl12xx: Fix problems in nvs file parsing
From: Luciano Coelho <coelho@ti.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
References: <1318922622-8356-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Dec 2011 16:23:43 +0200
Message-ID: <1322749423.8996.29.camel@cumari> (sfid-20111201_152357_254313_0F496313)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 09:23 +0200, Pontus Fuchs wrote: 
> A crafted nvs file could trick the driver into reading and writing
> beyond end of buffers.
> 
> Pontus Fuchs (2):
>   wl12xx: Validate FEM index from ini file and FW
>   wl12xx: Check buffer bound when processing nvs data
> 
>  drivers/net/wireless/wl12xx/boot.c |   14 ++++++++++++++
>  drivers/net/wireless/wl12xx/cmd.c  |   22 ++++++++++++++++++++++
>  2 files changed, 36 insertions(+), 0 deletions(-)

Applied both, tack!

-- 
Cheers,
Luca.

