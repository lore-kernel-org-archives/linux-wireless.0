Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:52173 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756198Ab1ALNFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 08:05:00 -0500
Subject: Re: [PATCH 1/2] mac80211: add hw configuration for max ampdu
 buffer size
From: Luciano Coelho <coelho@ti.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1294837049.18570.63.camel@wimaxnb.nmp.nokia.com>
References: <1294836052-16828-1-git-send-email-coelho@ti.com>
	 <1294837049.18570.63.camel@wimaxnb.nmp.nokia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Jan 2011 15:05:12 +0200
Message-ID: <1294837512.2097.34.camel@pimenta>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-01-12 at 13:57 +0100, Juuso Oikarinen wrote:
> On Wed, 2011-01-12 at 14:40 +0200, ext coelho@ti.com wrote:
> > From: Luciano Coelho <coelho@ti.com>
> > 
> > Some devices don't support the maximum AMDPU buffer size of 64, so we
> > need to add an option to configure this in the hardware configuration.
> > This value will be used in the ADDBA response instead of the value
> > suggested in the request, if the latter is greater than the max
> > supported.
> > 
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> > ---
> 
> Tested-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Thanks a lot for testing this for me, Juuso! I owe you one beer...
hrmmm... coke!

-- 
Cheers,
Luca.

