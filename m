Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:60801 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab0GaNXx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 09:23:53 -0400
To: Pazzo Da Legare <pazzodalegare@gmail.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Levi\, Shahar" <shahar_levi@ti.com>,
	Logan Gunthorpe <logang@deltatee.com>
Subject: Re: wl1271 firmware
References: <4C37BCA0.5090607@deltatee.com>
	<AC090B9732AB2B4DB7FF476E907FE660010685F34E@dnce02.ent.ti.com>
	<AANLkTilHNKeRZX5CMplyriTo2hTPBrz_z1_Zpwoy3SZx@mail.gmail.com>
	<AC090B9732AB2B4DB7FF476E907FE66001069662F2@dnce02.ent.ti.com>
	<AC090B9732AB2B4DB7FF476E907FE6600106966BA5@dnce02.ent.ti.com>
	<4C45ED36.2090604@deltatee.com>
	<AANLkTinjvF9UeV7d2aBUy6HfexuAeL_cdsVPGVxSRVMp@mail.gmail.com>
	<AANLkTinnYeJPV-xxg7DdPXnWW_kD7X1TVcd9HrhupJWS@mail.gmail.com>
	<1279780848.2322.31.camel@powerslave>
	<AANLkTilZhvGg2SUk5btpQQA3qj2k4rob4rTychDu7gXM@mail.gmail.com>
	<1279816465.1630.9.camel@powerslave>
	<AANLkTikHUe3qcon_sgnSpoNY=d5OVS9oBPLioNp0F5Kn@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sat, 31 Jul 2010 16:23:45 +0300
In-Reply-To: <AANLkTikHUe3qcon_sgnSpoNY=d5OVS9oBPLioNp0F5Kn@mail.gmail.com> (Pazzo Da Legare's message of "Sat\, 24 Jul 2010 01\:19\:53 +0200")
Message-ID: <87eiejeqe6.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pazzo Da Legare <pazzodalegare@gmail.com> writes:

> I attached what I got. Note that I have a limited buffer for system
> log so this is the last part only, I hope is enough.
>
> http://pastebin.com/7nLJeXkb

wl1271 sdio needs a special SDIO command to wakeup the firmware
properly from ELP. I recommend to check that your platform is using
that.

-- 
Kalle Valo
