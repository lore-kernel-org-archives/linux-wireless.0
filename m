Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60108 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752135AbXBJXlI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Feb 2007 18:41:08 -0500
Message-ID: <45CE5812.3000306@lwfinger.net>
Date: Sat, 10 Feb 2007 17:41:06 -0600
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	bcm43xx-dev@lists.berlios.de
Subject: Re: RFT: The real fix for BCM4311 and BCM4312
References: <45C96B8A.8010000@lwfinger.net> <1170830071.11150.62.camel@dv>	 <200702071443.19676.rjw@sisk.pl> <45C9D9D6.2070700@lwfinger.net> <a44ae5cd0702101530j38c983bfy9c1496fd50ca8b1c@mail.gmail.com>
In-Reply-To: <a44ae5cd0702101530j38c983bfy9c1496fd50ca8b1c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Miles Lane wrote:
> I am testing this patch applied to the wireless-net git tree.
> The card is a Linksys WPC54G.  The card is still getting very
> weak signal strength and the connection seems unresponsive
> most of the time.

As the subject says, the patch was for 4311 and 4312 cards. The 4318's are not yet fixed.

As measured by my RF receiver, the amplitude of the 4318 is about -70 dBm, the 4311 is about -60 dBm
and the 4306 is -50 dBm. All should have the -50 reading with my test setup.

I'm working on the power routines and will let you know.

Larry
