Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:37448 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900Ab3BGGD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 01:03:28 -0500
Message-ID: <1360216944.12095.49.camel@cumari.coelho.fi> (sfid-20130207_070331_719983_16A3E71B)
Subject: Re: [PATCH] mac80211: remove dynamic PS driver interface
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Date: Thu, 7 Feb 2013 08:02:24 +0200
In-Reply-To: <1360188507-25819-1-git-send-email-johannes@sipsolutions.net>
References: <1360188507-25819-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-06 at 23:08 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The functions were added for some sort of Bluetooth
> coexistence, but aren't used, so remove them again.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

This was only used by the wl12xx driver, but now the firmware does all
the dynamic PS handling by itself, so indeed this is not needed here
anymore.

Reviewed-by: Luciano Coelho <coelho@ti.com>

--
Luca.

