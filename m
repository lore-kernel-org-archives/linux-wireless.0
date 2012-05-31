Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:64947 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab2EaSWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 14:22:39 -0400
Received: by eeit10 with SMTP id t10so583009eei.19
        for <linux-wireless@vger.kernel.org>; Thu, 31 May 2012 11:22:38 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Arend van Spriel <arend@broadcom.com>,
	Florian Fainelli <florian@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: Master mode support in iwlagn?
Date: Thu, 31 May 2012 20:22:35 +0200
Message-ID: <1956850.etBVsmC5xH@sylvesterjr.cmi.ua.ac.be> (sfid-20120531_202243_140868_BE5C8F25)
In-Reply-To: <4FC76389.70600@broadcom.com>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be> <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 31 May 2012 14:26:49 Arend van Spriel wrote:
> 
> NetworkManager does support ad-hoc, but your hardware need to support
> beacon transmission for that as well. You could consider buying an AP.
> They are not that expensive ;-)

True, but I have enough to carry around already :-) And what if the MAC 
address needs to be registered first? From my point of view, it would be a lot 
easier if AP mode was supported... But you already guessed that probably, 
otherwise I would not have asked it in the first place, would I? ;-)

It is still (too) hard for Linux users to find a laptop with a wireless card 
that supports monitor mode, AP mode, decent packet injection, etc.

If you are wondering why I need that, I give a course about wireless 
networking and it is easier if I can test things from my own machine instead 
of having to run to the lab all the time :-)

Grz,
Erwin
