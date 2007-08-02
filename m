Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:56324 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXHBKY2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 06:24:28 -0400
Message-ID: <46B1B0CE.7010109@aurel32.net>
Date: Thu, 02 Aug 2007 12:24:14 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH] ssb-chipcommon: Add function to get processor clock
References: <200708010011.56753.mb@bu3sch.de> <200708020009.50374.mb@bu3sch.de> <46B19FFE.2010900@aurel32.net> <200708021140.25676.mb@bu3sch.de>
In-Reply-To: <200708021140.25676.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch a =E9crit :
> On Thursday 02 August 2007 11:12:30 Aurelien Jarno wrote:
>> Yep the merge of the bcm47xx is on my TODO list, but I want to finis=
h
>> the SSB parts first. I hope to finish that before the end of this we=
ek-end.
>>
>> About the bcm47xx arch code, my plan is to merge first a very simple
>> version that allow the machine to boot, but without support for CFE.
>>
>=20
> There are also mipscore patches in openwrt that need to get merged up=
stream.
> Do you take care of these, too?

Yep I am currently working on that.

--=20
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
