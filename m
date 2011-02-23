Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:39525 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755416Ab1BWNx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 08:53:26 -0500
Received: by mail-wy0-f181.google.com with SMTP id 42so2333750wyb.26
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 05:53:22 -0800 (PST)
Subject: Re: [PATCH] wl12xx: fix identification of beacon packets (debug)
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1297247114-4563-1-git-send-email-eliad@wizery.com>
References: <1297247114-4563-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Feb 2011 15:53:19 +0200
Message-ID: <1298469199.2104.22.camel@pimenta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-02-09 at 12:25 +0200, Eliad Peller wrote:
> for debugging purposes, wl12xx determines whether a rx packet
> is a beacon packet.
> 
> however, it checks only the frame_control subtype without checking
> the actual packet type, which leads to false identification in some
> cases.
> 
> use ieee80211_is_beacon instead.
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> --- 

Applied to wl12xx.  Thanks!

-- 
Cheers,
Luca.

