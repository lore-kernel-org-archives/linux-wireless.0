Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:37581 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755983Ab1D2T4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:56:53 -0400
Received: by eyg24 with SMTP id 24so1785640eyg.39
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 12:56:51 -0700 (PDT)
Subject: Re: [PATCH v2] wl12xx: Update Power Save Exit Retries Packets
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1302695570-14436-1-git-send-email-shahar_levi@ti.com>
References: <1302695570-14436-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 22:56:47 +0300
Message-ID: <1304107007.12586.155.camel@cumari> (sfid-20110429_215656_561209_69FEB287)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-04-13 at 14:52 +0300, Shahar Levi wrote:
> Reducing the retries of sending PS exit packets to the peer AP.
> That fix is to avoid sending unrealizable number of PS exit packets
> in case of ap lost.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied, thanks Shahar.

-- 
Cheers,
Luca.

