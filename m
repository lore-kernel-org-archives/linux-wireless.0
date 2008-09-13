Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:41046 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbYIMQuj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Sep 2008 12:50:39 -0400
Subject: Re: The new regulatory code kills my wireless
From: Marcel Holtmann <holtmann@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221294810.3700.3.camel@johannes.berg>
References: <48CAA8D6.1030605@lwfinger.net> <20080912174036.GC6134@tesla>
	 <48CAB90C.5090302@lwfinger.net>  <20080912191919.GA7722@tesla>
	 (sfid-20080912_211933_280898_C5E534CA)  <1221250959.5576.10.camel@johannes.berg>
	 <1221272779.6695.22.camel@californication>
	 <1221294810.3700.3.camel@johannes.berg>
Content-Type: text/plain
Date: Sat, 13 Sep 2008 18:51:13 +0200
Message-Id: <1221324673.6695.31.camel@californication> (sfid-20080913_185045_278177_A87FEAAA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > I am pretty happy that you caught it, because that was my whole point
> > from the discussion we had at OLS. The userspace part might not be in
> > place and we must ensure that everything still works as before :)
> 
> I thought your point was that you wanted regulatory_hint_regdom(...)
> that the driver can use to tell us what the EEPROM regulatory is, which
> wouldn't have been affected by this bug :) But anyway, yeah, it's a bug.

of course I want regulatory_hint_regdom :)

I was just trying to make clear how important it is to make sure we work
with a broken userspace or without userspace support at all

Regards

Marcel


