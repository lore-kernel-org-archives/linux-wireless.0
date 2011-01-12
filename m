Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:40583 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331Ab1ALMnD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:43:03 -0500
Subject: Re: [PATCH 1/2] mac80211: add hw configuration for max ampdu
 buffer size
From: Luciano Coelho <coelho@ti.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "juuso.oikarinen@nokia.com" <juuso.oikarinen@nokia.com>
In-Reply-To: <1294836052-16828-1-git-send-email-coelho@ti.com>
References: <1294836052-16828-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 14:43:17 +0200
Message-ID: <1294836197.2097.30.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 13:40 +0100, Coelho, Luciano wrote:
> From: Luciano Coelho <coelho@ti.com>
> 
> Some devices don't support the maximum AMDPU buffer size of 64, so we
> need to add an option to configure this in the hardware configuration.
> This value will be used in the ADDBA response instead of the value
> suggested in the request, if the latter is greater than the max
> supported.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> ---

This has not been tested, so it should probably have been sent as RFC.
Juuso is testing it at the moment (I think ;).


-- 
Cheers,
Luca.

