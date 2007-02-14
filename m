Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58814 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932616AbXBNW23 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 17:28:29 -0500
Message-ID: <45D38D06.40801@lwfinger.net>
Date: Wed, 14 Feb 2007 16:28:22 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joseph Jezak <josejx@gentoo.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>	 <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org>	 <200702092017.36950.mb@bu3sch.de>  <45CCD1B1.80709@gentoo.org>	 <1171457525.11116.19.camel@johannes.berg>  <45D35F65.7060001@lwfinger.net> <1171481180.6093.11.camel@johannes.berg>
In-Reply-To: <1171481180.6093.11.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2007-02-14 at 13:13 -0600, Larry Finger wrote:
> 
>> I've got a pair of BCM4306 rev 2 cards. One of them is certainly available. Its LEDS don't work
>> anymore, but the rest is functional.
> 
> Oh good. Do they actually work right now?
> 
> johannes

With the patches I pulled yesterday, they work to 54Mbs. Performance is not as good as the 4311 or
4318 cards, but usable.

Larry

