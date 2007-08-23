Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:55627 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbXHWWMI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:12:08 -0400
Message-ID: <46CE0636.3020303@lwfinger.net>
Date: Thu, 23 Aug 2007 17:12:06 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Broadcom Linux <bcm43xx-dev@lists.berlios.de>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  b43legacy: Initial port of new driver with bcm43xx PHY  code and ssb/mac80211 front end
References: <46CC755A.5030109@lwfinger.net> <20070823205141.GG2989@tuxdriver.com>
In-Reply-To: <20070823205141.GG2989@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Wed, Aug 22, 2007 at 12:41:46PM -0500, Larry Finger wrote:
> 
>> This patch ports the PHY and radio handling code of the softmac driver
>> to the mac80211 front end from b43. The resulting driver is known as
>> b43legacy.
> 
> I have added this to the b43 branch of wireless-dev.  It is available
> in 'everything' as well.

Thanks,

Larry
