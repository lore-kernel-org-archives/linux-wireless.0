Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:57693 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754971AbYAJBDv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2008 20:03:51 -0500
Message-ID: <47856EF1.9060502@lwfinger.net> (sfid-20080110_010357_304834_1588D61F)
Date: Wed, 09 Jan 2008 18:03:45 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH RFT] b43legacy: Remove the PHY spinlock
References: <200801092015.32042.mb@bu3sch.de>
In-Reply-To: <200801092015.32042.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This fixes a sparse warning about weird locking.
> The spinlock is not needed, so simply remove it.
> This also adds some sanity checks to the PHY and radio locking
> to protect against recursive locking.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> This patch is only compiletime tested.

The patch seems to work here on my BCM4306/2. I'll give it more testing; however, no problems yet.

Larry
