Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:54386 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab1ALM5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:57:35 -0500
Subject: Re: [PATCH 1/2] mac80211: add hw configuration for max ampdu
 buffer size
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: "ext coelho@ti.com" <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1294836052-16828-1-git-send-email-coelho@ti.com>
References: <1294836052-16828-1-git-send-email-coelho@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 14:57:29 +0200
Message-ID: <1294837049.18570.63.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 14:40 +0200, ext coelho@ti.com wrote:
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

Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

-Juuso

