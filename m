Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:33064 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760563Ab1D2T6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 15:58:06 -0400
Received: by mail-ey0-f175.google.com with SMTP id 27so1770204eye.34
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 12:58:03 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: add debugfs entries for dtim_interval and
 beacon_interval
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1303028447-16264-1-git-send-email-eliad@wizery.com>
References: <1303028447-16264-1-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Apr 2011 22:58:00 +0300
Message-ID: <1304107080.12586.156.camel@cumari> (sfid-20110429_215809_918765_47731F65)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2011-04-17 at 11:20 +0300, Eliad Peller wrote:
> When configuring ACX_WAKE_UP_CONDITIONS (before entering psm), we
> tell the firmware to wake up once in N DTIMs/beacons.
> 
> Allow control of this value via debugfs (for debugging purposes).
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---

Applied, thanks.

I've also added a new patch to s/strict_strtoul/kstrtoul/.

-- 
Cheers,
Luca.

