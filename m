Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:60152 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbXISDCz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Sep 2007 23:02:55 -0400
Message-ID: <46F09167.5020606@lwfinger.net>
Date: Tue, 18 Sep 2007 22:03:03 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: jt@hpl.hp.com
CC: John Linville <linville@tuxdriver.com>,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <20070917165435.GA26926@bougret.hpl.hp.com> <46EF5534.3030609@lwfinger.net> <20070918174202.GB1466@bougret.hpl.hp.com>
In-Reply-To: <20070918174202.GB1466@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Tourrilhes wrote:
> 
> 	Could you be more explicit ? Reverting the patch will just
> bring back the old bug, and the old code was obviously wrong. I don't
> like the idea of trading one bug for another bug. It looks to me like
> nobody knows what's exactly happening in the driver and we are just
> trying random fixes and see what breaks.
> 	Could you figure out what's exactly happening and make a
> proper fix ?
> 	Regards,

It took me nearly two days, but I finally found the correct fix for the bug that made it impossible
to set the essid. The resulting patch has been sent to John.

Larry
