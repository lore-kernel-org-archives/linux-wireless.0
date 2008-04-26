Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43600 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751553AbYDZF3Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 01:29:16 -0400
Message-ID: <4812BDA7.6080407@lwfinger.net> (sfid-20080426_072946_851486_580E5262)
Date: Sat, 26 Apr 2008 00:29:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix some TX/RX locking issues
References: <200804251929.09301.mb@bu3sch.de>
In-Reply-To: <200804251929.09301.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This fixes some TX/RX related locking issues.
> With this patch applied, some of the PHY transmission errors are fixed.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, this is for 2.6.26.
> 
> 

This patch cures the single PHY transmission error that always 
occurred when enabling DMA for BCM4311/2.

Emphatic ACK.

Larry

