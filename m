Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60099 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab1AXUQq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 15:16:46 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id p0OKGkVA010445
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 14:16:46 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0OKGj7N015498
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 14:16:45 -0600 (CST)
Received: from dlee73.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0OKGj5U023766
	for <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 14:16:45 -0600 (CST)
Received: from [172.24.64.12] (h64-12.vpn.ti.com [172.24.64.12])	by
 dlelxv22.itg.ti.com (8.13.8/8.13.8) with ESMTP id p0OKGiVs001588	for
 <linux-wireless@vger.kernel.org>; Mon, 24 Jan 2011 14:16:44 -0600
Subject: Re: [PATCH v2] wl12xx: add hw configuration for max supported
 AMDPU size
From: Luciano Coelho <coelho@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294838823-444-1-git-send-email-coelho@ti.com>
References: <1294838823-444-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 22:16:56 +0200
Message-ID: <1295900216.2063.0.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 14:27 +0100, Coelho, Luciano wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> The wl12xx chips do the AMDPU aggregation work in the firmware, but it
> supports a maximum of 8 frames per block.  Configure the mac80211 hw
> structure accordingly.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> ---

Applied to wl12xx.

-- 
Cheers,
Luca.

