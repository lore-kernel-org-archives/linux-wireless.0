Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49314 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754587Ab1CHQ4i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Mar 2011 11:56:38 -0500
Received: by mail-iy0-f182.google.com with SMTP id 12so5879290iyj.13
        for <linux-wireless@vger.kernel.org>; Tue, 08 Mar 2011 08:56:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299571030-11753-1-git-send-email-coelho@ti.com>
References: <1299502396-11455-1-git-send-email-coelho@ti.com>
	<1299571030-11753-1-git-send-email-coelho@ti.com>
Date: Tue, 8 Mar 2011 18:56:37 +0200
Message-ID: <AANLkTimYfoatwTWVZqGGoVEnX5nnYmo25m8UN4Z8DUnL@mail.gmail.com>
Subject: Re: [PATCH v2] wl12xx: fixes for 1281/1283 support - Add acx commands
From: "Levi, Shahar" <shahar_levi@ti.com>
To: Luciano Coelho <coelho@ti.com>
Cc: ido@wizery.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 3/8/11, Luciano Coelho <coelho@ti.com> wrote:
> This patch fixes up some issues with patch 03/15 in the wl128x support
> series:
>
> * Fix endianess issues;
> * Simplify sdio-specific block_size handling;
> * Minor changes in comments
>
> This has been compile-tested only.  I will test this changes after I
> go through the whole series and, if everything is still ok, I'll merge
> this patch into 03/15.
>
> Cc: Shahar Levi <shahar_levi@ti.com>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---
Looks good. Thanks for your fixes.

Reviewed-by: Shahar Levi <shahar_levi@ti.com>



-- 
All the best,
Shahar
