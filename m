Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64242 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2BHOmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 09:42:20 -0500
Received: by wgbdt10 with SMTP id dt10so667748wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 08 Feb 2012 06:42:19 -0800 (PST)
MIME-Version: 1.0
From: Claudio Rossi <rossi.claudio.82@gmail.com>
Date: Wed, 8 Feb 2012 15:41:59 +0100
Message-ID: <CAO1ZyKm1V6FF5aqbdRimdtJRZ+n9exkdUWh06P+i0uqcwweR4A@mail.gmail.com> (sfid-20120208_154223_639476_569B3B1A)
Subject: __floatunsidf and __fixunsdfsi undefined
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,
 I am trying to compile compat-wireless-3.2-rc6-3 on
a2.6.32-37-generic i686 GNU/Linux.
Everything goes well until I enter in phase 2, and I receive the
following WARNING which prevent the mac80211 modules to work properly
if installed

make -C /lib/modules/2.6.32-37-generic/build
M=/home/claudio/Programs/compat-wireless-3.2-rc6-3 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.32-37-generic'
  Building modules, stage 2.
  MODPOST 9 modules
WARNING: "__floatunsidf"
[/home/claudio/Programs/compat-wireless-3.2-rc6-3/net/mac80211/mac80211.ko]
undefined!
WARNING: "__fixunsdfsi"
[/home/claudio/Programs/compat-wireless-3.2-rc6-3/net/mac80211/mac80211.ko]
undefined!
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-37-generic'

the first time I compiled and installed the compat-wireless-3.2-rc6-3
it worked, but now it is not.

My distribution (UBUNTU 10.04) already comes with ath9k and mac80211.

Could  somebody give me an hint? I am a newbie at this

Thank you

Claudio


-- 
Claudio Rossi
-------------------
Office @ PoliTO: +39 011 5644194
