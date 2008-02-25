Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pne-smtpout1-sn1.fre.skanova.net ([81.228.11.98]:33807 "EHLO
	pne-smtpout1-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756865AbYBYT2O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 14:28:14 -0500
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: "'Johannes Berg'" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: RE: mac80211: Roaming issues.
Date: Mon, 25 Feb 2008 20:27:44 +0100
Message-ID: <006201c877e4$7eebf1a0$0b3ca8c0@gotws1589> (sfid-20080225_192818_901067_4AE0726F)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <1203967409.13162.134.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok,

I put some suggestions and patches together and come back to the list.

Lars
 

-----Original Message-----
From: Johannes Berg [mailto:johannes@sipsolutions.net] 
Sent: den 25 februari 2008 20:23
To: Lars Ericsson
Cc: linux-wireless@vger.kernel.org
Subject: Re: mac80211: Roaming issues.

Hi,

> Parallel with that I have been testing the roaming performance in 
> different environments/sites.
> I have discovered a number of improvement to the mac80211 driver that 
> will significantly speed up the roaming function.

Nit: mac80211 isn't a driver, it's the generic stack that is used/cooperates
with many drivers for many different types of hardware.

> The actual roaming is of course
> controlled form the wpa_supplicant,

That's actually true only if you use wpa_supplicant which with open networks
you're not forced to.

> but with my patches, the
> mac80211/wpa_supplicant will cooperate much smother and faster.

Sounds good.

> My question are:
> - Is this the place to discuss the mac80211 driver ?

Yes.

> - How is 'responsible' for the mac80211 driver ?

I pretty much am, but also see the MAINTAINERS file (still lists Michael Wu
and Jiri Benc who both don't do anything any more). Please copy me on all
patches, but of course send them to the list.

johannes

