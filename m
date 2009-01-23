Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37713 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbZAWPsz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:48:55 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Regression caused by commit e32b1b9a33759e8a83ac566c4c43f23ed5d6343b
Date: Fri, 23 Jan 2009 16:47:50 +0100
Cc: Alina Friedrichsen <x-alina@gmx.net>,
	John Linville <linville@tuxdriver.com>, samuel@sortiz.org,
	Kalle Valo <kalle.valo@iki.fi>, maximlevitsky@gmail.com,
	wireless <linux-wireless@vger.kernel.org>
References: <4979269F.1060500@lwfinger.net>
In-Reply-To: <4979269F.1060500@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901231647.50978.mb@bu3sch.de> (sfid-20090123_164900_087277_A06C769F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 03:08:31 Larry Finger wrote:
> With the commit of the subject, my b43 and p54usb devices stopped working. They could
> associate and authenticate with my WPA2 network, but never finish the DHCP connection and
> get an IP address. Surprisingly, my rtl8187 devices continued to work.
> 
> Please excuse the second sending of this. I missed wireless the first time.

Do you have a diff of this commit? Or at least the date it was committed?
I have some strange AP mode issue and it might be related to this. I just want to verify.

-- 
Greetings, Michael.
