Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:46128 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbYIMCZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 22:25:46 -0400
Subject: Re: The new regulatory code kills my wireless
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221250959.5576.10.camel@johannes.berg>
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla>
	 <48CAB90C.5090302@lwfinger.net>  <20080912191919.GA7722@tesla>
	 (sfid-20080912_211933_280898_C5E534CA)  <1221250959.5576.10.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 04:26:19 +0200
Message-Id: <1221272779.6695.22.camel@californication> (sfid-20080913_042551_082098_09D4D4DC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > Well no, IMHO people *should not* use the old regulatory stuff if
> > possible, the idea is to kill it ASAP, you should only use the old
> > regulatory stuff if you *need* to, meaning you have some dependency
> > on the old module parameter for some strange odd ball reason or if
> > you cannot compile and install crda or iw.
> 
> Well, TBH, I was just too lazy to do that ;)

I am pretty happy that you caught it, because that was my whole point
from the discussion we had at OLS. The userspace part might not be in
place and we must ensure that everything still works as before :)

Regards

Marcel


