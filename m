Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:53166 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab1AMLdi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 06:33:38 -0500
Subject: Re: [PATCH] wl12xx: don't modify the global supported band
 structures
From: Luciano Coelho <coelho@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "arik@wizery.com" <arik@wizery.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
In-Reply-To: <1294766718-2472-1-git-send-email-coelho@ti.com>
References: <1294766718-2472-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 13:33:32 +0200
Message-ID: <1294918412.2064.20.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-11 at 18:25 +0100, Coelho, Luciano wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> When 11a is not supported, we were modifying the global structure that
> contains the bands supported by the driver.  This causes problems when
> having more one wl12xx device in the same system because they all use
> the same global.  This also causes problems when the wl12xx_sdio
> module is removed and the wl12xx module remains.
> 
> Fix this problem by copying the band structure into the wl12xx
> instance.
> 
> Reported-by: Arik Nemtsov <arik@wizery.com>
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied and pushed to the wl12xx tree.

-- 
Cheers,
Luca.

