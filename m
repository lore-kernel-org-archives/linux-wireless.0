Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:61761 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYITVJK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:09:10 -0400
Message-ID: <48D56659.5060209@lwfinger.net> (sfid-20080920_230914_009185_096B3670)
Date: Sat, 20 Sep 2008 16:08:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Fix Bluetooth coexistence SPROM coding error for
 Motorola 7010 variant of BCM4306
References: <48d401da.Q+F4HRESoxeIVa3r%Larry.Finger@lwfinger.net>	 <200809201744.55571.mb@bu3sch.de> (sfid-20080920_174550_869772_E28C99C2) <1221943895.3023.1.camel@johannes.berg>
In-Reply-To: <1221943895.3023.1.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sat, 2008-09-20 at 17:44 +0200, Michael Buesch wrote:
>> On Friday 19 September 2008 21:47:38 Larry Finger wrote:
>>> An additional BCM4306 has been found with the Bluetooth coexistence
>>> SPROM coding error.
> 
> Does anyone actually make laptops that use these bluetooth coexistence
> pins? All CSR bluetooth chips do it automatically I'm told, maybe we
> should just kill them completely.

I don't know, but I really wouldn't want to blindly kill bluetooth
coexistence. After all, most cards have their SPROMs programmed
correctly. Only the PCI-versions of the BCM4306 and the ASUS BCM4318
seem to have the problem.

I have been working the openSUSE and Ubuntu support forums, which is
where I have been getting these new devices to add to the work-around.

Larry

