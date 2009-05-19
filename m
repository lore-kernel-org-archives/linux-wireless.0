Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([207.115.11.52]:44309 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbZESOct (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:32:49 -0400
Message-ID: <4A12C2F7.4010301@lwfinger.net>
Date: Tue, 19 May 2009 09:32:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?GB2312?B?u8bK2M36?= <huangsw@temobi.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: Re: [PATCH 2/2 V2] b43legacy: Fix locking problem
References: <4A0DD306.30705@lwfinger.net>, <20090518200354.GK2814@tuxdriver.com>, <4A122882.2070409@lwfinger.net> <200905191452419680632@temobi.com>
In-Reply-To: <200905191452419680632@temobi.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

»ÆÊØÍú wrote:
> Hello everybody , my embedded system bases on arm( Intel's XScale
> ixp425),kernel is downloaded from kernel.org£¬version is 2.6.26.6
>  
> when i compile the B43 driver into kernel ,i can not to make BCM4318 and
> BCM4306  to work in AP mode.
>  
>  
> can you tell me whether 4318 and 4306 really support ap mode?
>  
> Thansk for any hints

I am not certain that the b43 or mac80211 drivers in 2.6.26 will work in AP
mode; however, if you use 2.6.29 and hostapd with version 0.6.X, then your
BCM43xx devices should work. See the article at
http://forums.opensuse.org/network-internet/wireless/410475-how-setup-access-point.html.


Larry

