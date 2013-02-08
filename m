Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:37904 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946121Ab3BHJUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 04:20:50 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id r189Kn97007109
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:20:49 -0600
Received: from DFLE73.ent.ti.com (dfle73.ent.ti.com [128.247.5.110])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189KnHt029845
	for <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:20:49 -0600
Received: from [172.24.79.4] (h79-4.vpn.ti.com [172.24.79.4])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id r189KlWF009308	for
 <linux-wireless@vger.kernel.org>; Fri, 8 Feb 2013 03:20:48 -0600
Message-ID: <1360315191.12803.25.camel@cumari.coelho.fi> (sfid-20130208_102053_539446_75BAA127)
Subject: Re: [PATCH] wlcore: use single-role version when verifying the PLT
 firmware
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
Date: Fri, 8 Feb 2013 11:19:51 +0200
In-Reply-To: <1355300062-19677-1-git-send-email-coelho@ti.com>
References: <1355300062-19677-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 10:14 +0200, Luciano Coelho wrote:
> The PLT firmware used by wl12xx for calibration always has the same
> version number as the single-role firmware.
> 
> Currntly the driver rejects the PLT firmware since anything that is
> not single-role uses the multi-role version.  Fix this by using the
> single-role version for everything except multi-role.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

Applied.

--
Luca.

