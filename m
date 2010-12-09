Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005Ab0LIPZo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 10:25:44 -0500
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	=?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <4D00F3C3.6040801@lwfinger.net>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	 <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
	 <4CFEFD8D.1080808@lwfinger.net>
	 <AANLkTi=mDh9wkp+u3ebuXqF8Q-rTW_YCtee3CmCBdWTh@mail.gmail.com>
	 <4D00F3C3.6040801@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 16:25:38 +0100
Message-ID: <1291908338.3540.16.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-09 at 09:20 -0600, Larry Finger wrote:

> It has a rev 2 PHY, and a rev 4 0x2055 radio.
> 
> I am willing to buy a higher PHY rev device for testing. Any idea what is in a
> 4324A-BRCM1036?

It says BCM94322 on the image, and if that's any indication, I have a
4322 with pci ID 14e4:432b (but it's an Apple build):

b43-phy0: Broadcom 4322 WLAN found (core revision 16)
b43-phy0 debug: Found PHY: Analog 8, Type 4, Revision 4
b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2056, Revision 3

johannes

