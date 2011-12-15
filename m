Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:33221 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751353Ab1LOIzM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:55:12 -0500
Received: by mail-lpp01m010-f44.google.com with SMTP id h2so1331294laa.17
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:55:11 -0800 (PST)
Subject: Re: [PATCH] Set wlvif->ps_compl to NULL in before return
From: Luciano Coelho <coelho@ti.com>
To: Pontus Fuchs <pontus.fuchs@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1323869543-2846-1-git-send-email-pontus.fuchs@gmail.com>
References: <1323869543-2846-1-git-send-email-pontus.fuchs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Dec 2011 10:55:07 +0200
Message-ID: <1323939307.2800.183.camel@cumari> (sfid-20111215_095515_918835_A696C100)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-12-14 at 14:32 +0100, Pontus Fuchs wrote: 
> wl1271_configure_suspend_sta leaves a stale stack declared
> completion in wlvif->ps_compl. Set it to NULL before returning.
> 
> Signed-off-by: Pontus Fuchs <pontus.fuchs@gmail.com>
> ---

Applied with a small fix.  wl->ps_compl was used, which doesn't exist
anymore.  I changed it to wlvif->ps_compl before applying.

-- 
Cheers,
Luca.

