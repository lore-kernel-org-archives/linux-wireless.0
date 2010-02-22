Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f184.google.com ([209.85.216.184]:47333 "EHLO
	mail-px0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0BVSFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 13:05:43 -0500
Received: by pxi14 with SMTP id 14so1465675pxi.15
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2010 10:05:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1266820722-20202-7-git-send-email-juuso.oikarinen@nokia.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	<1266820722-20202-7-git-send-email-juuso.oikarinen@nokia.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 22 Feb 2010 10:05:23 -0800
Message-ID: <43e72e891002221005q4840593bs8b937d6d82b44b3c@mail.gmail.com>
Subject: Re: [PATCH 06/22] wl1271: Divided driver to two separate modules
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 21, 2010 at 10:38 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
>
> Divided wl1271 driver to wl1271 "core" and wl1271_spi modules in preparation
> of integration of the SDIO implementation.
>
> Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Which one is it, Reviewed or SOB? If both then just use SOB.

  Luis
