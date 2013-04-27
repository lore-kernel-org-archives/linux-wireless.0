Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:46746 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3D0UVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Apr 2013 16:21:40 -0400
Message-ID: <1367094096.8445.3.camel@jlt4.sipsolutions.net> (sfid-20130427_222144_472244_87CD5D41)
Subject: Re: Intel Centrino Wireless-N 2230 (rev c4) bug
From: Johannes Berg <johannes@sipsolutions.net>
To: Paolo Zaffino <p.zaffino@unicz.it>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Sat, 27 Apr 2013 22:21:36 +0200
In-Reply-To: <517C18A4.70402@unicz.it> (sfid-20130427_202857_500207_32CC2EAC)
References: <517BD02A.5060904@unicz.it>
	  (sfid-20130427_151940_748350_F10D6AF1) <1367085173.8445.0.camel@jlt4.sipsolutions.net>
	 <517C18A4.70402@unicz.it> (sfid-20130427_202857_500207_32CC2EAC)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-04-27 at 20:27 +0200, Paolo Zaffino wrote:
> First of all thanks for your support.
> Can you give me any advice on what look for in my system?
> I really haven't idea about this strange situation.

Well, make sure you kill all supplicant processes. I'm guessing you're
not using your distro's tools (e.g. network-manager) but starting your
own, and the distro init scripts also start a supplicant process.

Anyway, that's about all I can help you with, everything else would be
distro specific and then you should ask them for help. Most likely
they'll just tell you to use the "sanctioned" way though.

johannes

