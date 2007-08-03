Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:47532 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758395AbXHCQNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 12:13:10 -0400
Message-ID: <46B35414.2030300@lwfinger.net>
Date: Fri, 03 Aug 2007 11:13:08 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/10] Port of bcm43xx from softmac to mac80211
References: <46b1fde7.JR5zA75dJy7VnTEq%Larry.Finger@lwfinger.net> <20070803163044.3d0fff1b@morte>
In-Reply-To: <20070803163044.3d0fff1b@morte>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano,

Thanks for taking the time to review the patches. As Michael wrote, the bulk of the patch comes from 
his V4 code, but it's good to have it looked through.



Stefano Brivio wrote:

>>  /* PHYVersioning */
>> -#define BCM43xx_PHYTYPE_A		0x00
> 
> So OK, let's remove support for A PHYs. I never got done with it and maybe it
> had to be rewritten from scratch anyway.

This removal is _ONLY_ for the driver that uses V3 firmware. It will ultimately be limited to B PHYs 
and removal of the A PHY stuff will happen anyway. AFAIK, support of A PHYs will be implemented 
(eventually) in the V4 driver.

All suggestions implemented.

Larry

