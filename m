Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55496 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab3FQJGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 05:06:01 -0400
Message-ID: <1371459957.3028.4.camel@cumari.coelho.fi> (sfid-20130617_110610_797631_CE838016)
Subject: Re: [PATCH] wl12xx: fix minimum required firmware version for
 wl127x multirole
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <levipearson@gmail.com>, <hashcode0f@gmail.com>
Date: Mon, 17 Jun 2013 12:05:57 +0300
In-Reply-To: <1368171177-13682-1-git-send-email-coelho@ti.com>
References: <1368171177-13682-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-10 at 10:32 +0300, Luciano Coelho wrote:
> There was a typo in commit 8675f9 (wlcore/wl12xx/wl18xx: verify
> multi-role and single-role fw versions), which was causing the
> multirole firmware for wl127x (WiLink6) to be rejected.  The actual
> minimum version needed for wl127x multirole is 6.5.7.0.42.
> 
> Reported-by: Levi Pearson <levipearson@gmail.com>
> Reported-by: Michael Scott <hashcode0f@gmail.com>
> Cc: stable@kernel.org # 3.9+
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

This patch has been pushed up and applied in v3.11-rc6.

--
Luca.

