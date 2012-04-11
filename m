Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47178 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761402Ab2DKXCH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 19:02:07 -0400
Date: Thu, 12 Apr 2012 08:01:57 +0900
From: Norbert Preining <preining@logic.at>
To: Dave Jones <davej@redhat.com>, Ted Ts'o <tytso@mit.edu>,
	David Miller <davem@davemloft.net>, egrumbach@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, ilw@linux.intel.com
Subject: Re: 3.4-rc2, ilwagn still most of the time completely unusable
Message-ID: <20120411230157.GC12332@gamma.logic.tuwien.ac.at> (sfid-20120412_010228_544275_0B6E685C)
References: <20120330011734.GH6277@gamma.logic.tuwien.ac.at> <20120411023747.GA10126@gamma.logic.tuwien.ac.at> <20120410.225451.92022308007980352.davem@davemloft.net> <20120411184047.GJ12044@thunk.org> <20120411200105.GA22002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120411200105.GA22002@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mi, 11 Apr 2012, Dave Jones wrote:
>  > I'll note that I've been having troubles with my iwlagn driver losing
>  > the ability to connect to WPA2 authenticated AP's at work (Google
>  > Cambridge).  This has been true for since sometime around 3.0; my
>  > excuse for why I haven't tried bisecting it is that it can take
>  > several hours for the bug to manifest itself, and when it does, it's
>  > much simpler to either (a) reboot, or (b) rmmod iwlagn and then
>  > modprobe iwlagn.

Agreed. 150%

> iwlwifi has a debug module option which generates a ton of spew, but
> the Intel developers have managed to diagnose several iwlwifi problems

I sent already several times *loads* of these dumps to the developers.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
MELLON UDRIGLE (n.)
The ghastly sound made by traditional folksingers.
			--- Douglas Adams, The Meaning of Liff
