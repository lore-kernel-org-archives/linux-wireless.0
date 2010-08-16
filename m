Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:50899 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689Ab0HPUri (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Aug 2010 16:47:38 -0400
Message-ID: <4C69A3E4.1080807@bu3sch.de>
Date: Mon, 16 Aug 2010 22:47:32 +0200
From: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
MIME-Version: 1.0
To: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	Larry Finger <larry.finger@lwfinger.net>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 4/4] b43: N-PHY: Implement RX core state setting for rev.2
 and earlier PHYs
References: <1281991157-1557-1-git-send-email-netrolller.3d@gmail.com> <1281991157-1557-2-git-send-email-netrolller.3d@gmail.com> <1281991157-1557-3-git-send-email-netrolller.3d@gmail.com> <1281991157-1557-4-git-send-email-netrolller.3d@gmail.com> (sfid-20100816_223927_806858_FFFFFFFFDFC5176A)
In-Reply-To: <1281991157-1557-4-git-send-email-netrolller.3d@gmail.com> (sfid-20100816_223927_806858_FFFFFFFFDFC5176A)
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/16/2010 10:39 PM, Gábor Stefanik wrote:
> +static void b43_nphy_set_rx_core_state(struct b43_wldev *dev, u8 mask)
> +{
> +	struct b43_phy *phy =&dev->phy;
> +	struct b43_phy_n *nphy = phy->n;
> +	u16 buf[16];

> +	if (maskbits&  0x3 != 0x3) {

Does this even compile? I don't see maskbits being defined.

-- 
Greetings Michael.
