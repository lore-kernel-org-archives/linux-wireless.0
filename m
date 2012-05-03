Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:51353 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754488Ab2ECM73 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 08:59:29 -0400
Received: by lahe6 with SMTP id e6so1679648lah.18
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 05:59:26 -0700 (PDT)
Message-ID: <1336049964.12189.34.camel@cumari.coelho.fi> (sfid-20120503_145933_535188_E19F02C3)
Subject: Re: [PATCH] wlcore/wl12xx: implement better beacon loss handling
From: Luciano Coelho <coelho@ti.com>
To: Bartosz.Markowski@tieto.com
Cc: linux-wireless@vger.kernel.org, arik@wizery.com, eliad@wizery.com
Date: Thu, 03 May 2012 15:59:24 +0300
In-Reply-To: <538FB72AA9C7314998FCE2FB41335C5A208413C7C2@EXMB02.eu.tieto.com>
References: <538FB72AA9C7314998FCE2FB41335C5A208413C7C2@EXMB02.eu.tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-04-26 at 10:35 +0300, Bartosz.Markowski@tieto.com wrote:
> Make use of REGAINED_BSS_EVENT and instead of reporting connection
> loss immediately on each BEACON_LOSE event, try if not regained
> in reasonable period of time.
> 
> Signed-off-by: bartosz.markowski <bartosz.markowski@tieto.com>
> ---

Applied, thanks!

Eliad has been working in a slightly different implementation for this
in our internal trees.  In the future we will upstream his
implementation on top of this.

Luca.

