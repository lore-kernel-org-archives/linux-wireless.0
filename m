Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:49451 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab1DET3y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Apr 2011 15:29:54 -0400
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	George Kashperko <george@znau.edu.ua>,
	b43-dev@lists.infradead.org
In-Reply-To: <1302033463-1846-1-git-send-email-zajec5@gmail.com> (sfid-20110405_212040_948160_FFFFFFFFD5D634B4)
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	 (sfid-20110405_212040_948160_FFFFFFFFD5D634B4)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Apr 2011 21:29:43 +0200
Message-ID: <1302031783.1923.4.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-04-05 at 21:57 +0200, Rafał Miłecki wrote: 
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> ---
> I believe this driver implements AI support in the proper way. This introduces
> support for the *bus* and lets drivers register for specific cores. It was
> tested with b43 and BCM4313, reading PHY info works fine.

Looks pretty good.
I currently don't have the time to go through the stuff in detail, 
but from it quick look you get a *thumbs up* from me :)

-- 
Greetings Michael.

