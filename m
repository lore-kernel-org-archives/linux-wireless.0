Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:60099 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716AbYLSSOe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 13:14:34 -0500
Message-ID: <494BE47D.7050708@lwfinger.net> (sfid-20081219_191440_140021_B0CFBFBF)
Date: Fri, 19 Dec 2008 12:14:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] b43: Suspend MAC while killing the radio
References: <200812191840.00731.mb@bu3sch.de>
In-Reply-To: <200812191840.00731.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> We should suspend the MAC, before we kill the radio. This gives
> the MAC a chance to leave any TX/RX state and it avoids races on
> the PHY/RADIO registers.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> For 2.6.29

This patch removes the messages. ACK.

Larry

