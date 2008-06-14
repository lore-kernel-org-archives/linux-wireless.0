Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:45681 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbYFNJwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Jun 2008 05:52:16 -0400
Date: Sat, 14 Jun 2008 12:51:30 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Maciek Kaliszewski <mkalkal@interia.pl>,
	linux-wireless@vger.kernel.org
Subject: Re: iwl3945 and WPA
Message-ID: <20080614095130.GG5062@jm.kir.nu> (sfid-20080614_115221_356900_0F9DA730)
References: <4852658A.4040402@interia.pl> <20080613132317.GB5333@tuxdriver.com> <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com> <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv> <4852D6EB.3020304@interia.pl> <1213391287.22425.31.camel@dv> <4852F389.1070506@interia.pl> <20080614093851.GF5062@jm.kir.nu> <1213436523.3860.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1213436523.3860.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 14, 2008 at 11:42:03AM +0200, Johannes Berg wrote:

> Yeah, it should be in there. Building a 64-bit wpa supplicant is quite
> hard unless you have all 64-bit libs already, so maybe it's easier to
> apply Dave's patches.

Yes, I know.. I did it once on PS3 and it took some time figuring out
which packages I need to install to get proper 64-bit libraries and
compiler available. It didn't help that that was the first time I used
the particular distro, but anyway, it is doable if one does not want to
update the kernel. I hope that the patches go in soon, though, since
neither patching a kernel or building 64-bit user space from scratch is
something I would consider a good end user requirement.. ;-)

-- 
Jouni Malinen                                            PGP id EFC895FA
