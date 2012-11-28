Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:48292 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab2K1OfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:35:19 -0500
Message-ID: <1354113278.25524.28.camel@cumari.coelho.fi> (sfid-20121128_153522_886660_D110ADAD)
Subject: Re: [PATCH 01/20] wl12xx/wl18xx: update default fw logger's settings
From: Luciano Coelho <coelho@ti.com>
To: Arik Nemtsov <arik@wizery.com>
CC: <linux-wireless@vger.kernel.org>, Ido Reis <idor@ti.com>
Date: Wed, 28 Nov 2012 16:34:38 +0200
In-Reply-To: <1354095769-8724-2-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
	 <1354095769-8724-2-git-send-email-arik@wizery.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 11:42 +0200, Arik Nemtsov wrote:
> From: Ido Reis <idor@ti.com>
> 
> update the fw logger mode to continuous, and output to dbgpins (uart).
> 
> Signed-off-by: Ido Reis <idor@ti.com>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---

I think for upstream it's best to keep it as it was? Most people won't
have the debug pins and won't want to get them continuously.  Sending to
the host and only on demand seems more reasonable to me.

--
Luca.

