Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:49394 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935662Ab1ETMCv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2011 08:02:51 -0400
Subject: Re: [RFC/PATCH 01/13] net: wl12xx: sdio: id_tables should be
 __devinitconst
From: Luciano Coelho <coelho@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
In-Reply-To: <1305321990-22041-2-git-send-email-balbi@ti.com>
References: <1305321990-22041-1-git-send-email-balbi@ti.com>
	 <1305321990-22041-2-git-send-email-balbi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 May 2011 15:02:45 +0300
Message-ID: <1305892965.12586.1663.camel@cumari> (sfid-20110520_140310_239257_9F7EE542)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-05-14 at 00:26 +0300, Felipe Balbi wrote:
> That's only needed during init anyway, let's free
> some space after we're done probing.
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---

Applied, this one.  Thanks, Felipe!

-- 
Cheers,
Luca.

