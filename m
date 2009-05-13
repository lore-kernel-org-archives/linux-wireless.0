Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 42.248.sfcn.org ([160.7.248.42]:37204 "HELO mail.mypals.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751578AbZEMF3L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 May 2009 01:29:11 -0400
From: Alf <alf@mypals.org>
To: Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: ath5k in 2.6.29.1 won't associate with AP
Date: Tue, 12 May 2009 23:29:14 -0600
Cc: Bob Copeland <me@bobcopeland.com>,
	Tulio Magno Quites Machado Filho <tuliom@quites.com.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <200905021218.23747.alf@mypals.org> <200905052142.38780.alf@mypals.org> <40f31dec0905120636i592e29e3n29b88c763fd9739e@mail.gmail.com>
In-Reply-To: <40f31dec0905120636i592e29e3n29b88c763fd9739e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200905122329.14829.alf@mypals.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 12 May 2009 07:36:04 am Nick Kossifidis wrote:
> Hmm, do you use a driver from your vendor (the inf files etc from CD)
> or a generic one from the net ?

I downloaded them from DLink's website.  They have two versions, I used the 
older one.  The most recent didn't work.

> It's possible that your vendor uses hardcoded settings on the driver
> instead of EEPROM settings so tx power wont work as expected and
> that's why you can't connect on the AP. Both ath5k and MadWiFi try to
> use EEPROM settings, they don't use any hardcoded settings (not even
> default values in case of a corrupted EEPROM -we should fix that in
> the future).

That's one possible explanation.  I can send you the driver I'm using 
through ndiswrapper to test your hypothesis.  You can also send me a patch 
that would set the power level to a hardcoded value instead of the EEPROM to 
test it as well.  Just let me know how I can be of help in finding and 
fixing the problem.

-- 
Alf
@
