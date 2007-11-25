Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58850 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbXKYPys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 10:54:48 -0500
Message-ID: <47499AC9.9060703@lwfinger.net> (sfid-20071125_155454_168934_AD1F6785)
Date: Sun, 25 Nov 2007 09:54:49 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: stefano.brivio@polimi.it, bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: reinit on too many PHY TX errors
References: <200711251110.33613.mb@bu3sch.de>
In-Reply-To: <200711251110.33613.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> From: Stefano Brivio <stefano.brivio@polimi.it>
> 
> Restart the hardware on too many PHY TX errors. A thousand PHY TX errors
> per 15 seconds means we won't be able to recover for sure

Do we know what causes the PHY TX errors? On the BCM4311/2, I always get one that I have not been 
able to fix.

Larry


