Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57944 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1ASHFP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 02:05:15 -0500
Subject: Re: [PATCH v2] wl12xx: Add channel 14 to list of supported 2ghz
 channels
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1295379592-6223-1-git-send-email-arik@wizery.com>
References: <1295379592-6223-1-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Jan 2011 09:05:17 +0200
Message-ID: <1295420717.10758.111.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-01-18 at 20:39 +0100, Arik Nemtsov wrote:
> Channel 14 is only supported in Japan (JP country code in).
> The FW limits tranmissions to CCK only on this channel.
> 
> Tested in both STA and AP modes to work correctly.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

Good, thanks Arik!

I guess instead of (JP country code in) you meant (JP country code in
regdb), right? I'll fix that manually before applying.

-- 
Cheers,
Luca.

