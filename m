Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37926 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946101Ab3BHJV0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:21:26 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r189LQQ7007409
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:26 -0600
Received: from DLEE74.ent.ti.com (dlee74.ent.ti.com [157.170.170.8])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189LQet030659
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:26 -0600
Received: from [172.24.79.4] (h79-4.vpn.ti.com [172.24.79.4])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189LO2c009604	for
 <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:21:25 -0600
Message-ID: <1360315228.12803.26.camel@cumari.coelho.fi> (sfid-20130208_102322_030557_E0834AB5)
Subject: Re: [PATCH 0/5] ti wlan drivers: clean-up platform_data stuff (part
 1)
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Fri, 8 Feb 2013 11:20:28 +0200
In-Reply-To: <1358952038-5982-1-git-send-email-coelho@ti.com>
References: <1358952038-5982-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-01-23 at 16:40 +0200, Luciano Coelho wrote:
> Hi,
> 
> These are my initial patches where I started cleaning up the platform
> data stuff so we can start moving to using DT more easily later.
> 
> There is still a lot more to clean up before making all this DT
> friendly, so I'll send a few more patchsets soon.  I'm sending this
> already because I don't want to pile up too many patches.  Maybe in
> small batches I have a chance of getting some review. :P

Applied the series, including v2 of 2/5 and 5/5.

--
Luca.

