Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f177.google.com ([209.85.216.177]:58319 "EHLO
	mail-qy0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab0LIOLD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Dec 2010 09:11:03 -0500
Received: by qyk27 with SMTP id 27so2079873qyk.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Dec 2010 06:11:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CFEFD8D.1080808@lwfinger.net>
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>
	<AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>
	<4CFEFD8D.1080808@lwfinger.net>
Date: Thu, 9 Dec 2010 15:11:02 +0100
Message-ID: <AANLkTi=mDh9wkp+u3ebuXqF8Q-rTW_YCtee3CmCBdWTh@mail.gmail.com>
Subject: Re: [PATCH 0/4] Make N-PHY support experimental
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/12/8 Larry Finger <Larry.Finger@lwfinger.net>:
> I have a bit more info regarding the problem with WPA2 encryption on an N PHY.
> As shown in the NetworkManager log attached, Authentication is successful, but
> DHCP fails. Either the transmit data is improperly encrypted, or the decryption
> fails. I will use wireshark to sort that out. Note: Using software encryption
> makes no difference.

Hm, I expected software encryption to work, that's weird. I don't
really have nice access to my development machine, so some tests would
be great.

-- 
Rafał
