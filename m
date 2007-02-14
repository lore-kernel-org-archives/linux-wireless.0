Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34617 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932461AbXBNTNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Feb 2007 14:13:55 -0500
Message-ID: <45D35F65.7060001@lwfinger.net>
Date: Wed, 14 Feb 2007 13:13:41 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Joseph Jezak <josejx@gentoo.org>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org, Bcm43xx-dev@lists.berlios.de,
	John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] bcm43xx: Fix code for spec changes of 2/7/2007
References: <45cca236.+lL/rsW3DbM3elnk%Larry.Finger@lwfinger.net>	 <45CCBB93.2040703@lwfinger.net> <45CCC5DF.8010001@gentoo.org>	 <200702092017.36950.mb@bu3sch.de>  <45CCD1B1.80709@gentoo.org> <1171457525.11116.19.camel@johannes.berg>
In-Reply-To: <1171457525.11116.19.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> supported cards or a bug fix?
> 
> Hmm. Same I guess, use the new check for new hw and the old check for
> old hw, i.e. assume it's the former and not a bug fix (until tested
> otherwise.)
> 
> I think our best bet is to treat the older hw the same as the older
> driver does.
> 
> A bigger problem, IMO, is that we'd have to support all the older
> microcode things which is a bit tricky since things in shm have moved a
> lot... Maybe we should find a third maintainer who has access to a
> couple of old cards :)

I've got a pair of BCM4306 rev 2 cards. One of them is certainly available. Its LEDS don't work
anymore, but the rest is functional.

Larry
