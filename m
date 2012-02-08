Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2860 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496Ab2BHPGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 10:06:43 -0500
Message-ID: <4F328F76.2040406@broadcom.com> (sfid-20120208_160646_925523_984628F0)
Date: Wed, 8 Feb 2012 16:06:30 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Claudio Rossi" <rossi.claudio.82@gmail.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: __floatunsidf and __fixunsdfsi undefined
References: <CAO1ZyKm1V6FF5aqbdRimdtJRZ+n9exkdUWh06P+i0uqcwweR4A@mail.gmail.com>
In-Reply-To: <CAO1ZyKm1V6FF5aqbdRimdtJRZ+n9exkdUWh06P+i0uqcwweR4A@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2012 03:41 PM, Claudio Rossi wrote:
> Dear all,
>  I am trying to compile compat-wireless-3.2-rc6-3 on
> a2.6.32-37-generic i686 GNU/Linux.
> Everything goes well until I enter in phase 2, and I receive the
> following WARNING which prevent the mac80211 modules to work properly
> if installed
> 
> make -C /lib/modules/2.6.32-37-generic/build
> M=/home/claudio/Programs/compat-wireless-3.2-rc6-3 modules
> make[1]: Entering directory `/usr/src/linux-headers-2.6.32-37-generic'
>   Building modules, stage 2.
>   MODPOST 9 modules
> WARNING: "__floatunsidf"
> [/home/claudio/Programs/compat-wireless-3.2-rc6-3/net/mac80211/mac80211.ko]
> undefined!
> WARNING: "__fixunsdfsi"
> [/home/claudio/Programs/compat-wireless-3.2-rc6-3/net/mac80211/mac80211.ko]
> undefined!
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-37-generic'
> 
> the first time I compiled and installed the compat-wireless-3.2-rc6-3
> it worked, but now it is not.
> 
> My distribution (UBUNTU 10.04) already comes with ath9k and mac80211.
> 
> Could  somebody give me an hint? I am a newbie at this
> 
> Thank you
> 
> Claudio
> 
> 

If I am not mistaken, those symbols should be provided by gcc. Maybe
this is a known gcc issue. Try your favorite search engine.

Gr. AvS

