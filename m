Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog133.obsmtp.com ([74.125.149.82]:51179 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933717Ab2DLMmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 08:42:38 -0400
Received: by lagv3 with SMTP id v3so1994449lag.13
        for <linux-wireless@vger.kernel.org>; Thu, 12 Apr 2012 05:42:35 -0700 (PDT)
Message-ID: <1334234553.10398.37.camel@cumari> (sfid-20120412_144241_700512_682B20E6)
Subject: Re: [PATCH 00/16] wl12xx/wl1251/wlcore: reorganize drivers part 1
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com
Date: Thu, 12 Apr 2012 15:42:33 +0300
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-04-11 at 12:37 +0300, Luciano Coelho wrote: 
> Hi,
> 
> This is the first batch of patches from the reorganization our drivers and
> preparation for the inclusion of the new wl18xx driver.
> 
> First of all, we moved all the TI wireless drivers into a new subdirectory
> drivers/net/wireless/ti so we can keep all our drivers in the same place.
> 
> Then, we started splitting the wl12xx driver into a core module (wlcore) and a
> lower driver (wl12xx).  This was done because the wl18xx driver shares a lot of
> the same code.  The wlcore module will eventually become a kind of common
> library for the different lower drivers to use.  This patchset contains only
> the initial part of this work.  More will follow soon.
> 
> John, please let me know if it's okay to include the first patch, with which I
> moved stuff around, in my tree so we can keep things in sync more easily.
> 
> Please review.

Applied and pushed this series to wl12xx.git/master.

-- 
Cheers,
Luca.

