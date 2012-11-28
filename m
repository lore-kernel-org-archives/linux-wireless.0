Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44043 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2K1Olh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 09:41:37 -0500
Message-ID: <1354113722.9345.28.camel@jlt4.sipsolutions.net> (sfid-20121128_154140_855788_731F33A5)
Subject: Re: iwlwifi hibernate / suspend issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Kapitza <j.kapitza@schwarze-allianz.de>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 28 Nov 2012 15:42:02 +0100
In-Reply-To: <50B62254.9070700@schwarze-allianz.de>
References: <50B61C71.6060007@schwarze-allianz.de>
	 (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net>
	 <50B62254.9070700@schwarze-allianz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 15:40 +0100, Jens Kapitza wrote:
> Am 28.11.2012 15:30, schrieb Johannes Berg:
> > No, the firmware is stopped anyway during suspend, the card is powered
> > off. Can you please post message output? We should read the rfkill state
> > during resume, maybe there's a race. Also, what kernel version?
> >
> > johannes
> root@jens-S4216:/home/jens# uname -a
> Linux jens-S4216 3.6.7 #2 SMP Sat Nov 24 19:30:21 CET 2012 x86_64 x86_64 
> x86_64 GNU/Linux
> 
> if testet linux-image-3.7.0-rc7-wl+_3.7.0-rc7-wl+ with same issue
> 
> where can i found the output? never startet the debug mode in linux-kernel ?

just enter "dmesg" and pastebin the result somewhere

johannes

