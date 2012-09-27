Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:43197 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab2I0NlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 09:41:03 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Alper Yilmaz <alperyilmaz@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: 802.1X can associate but can not connect
References: <CAFDG9nuce-T0paZavi3D1wnNLHsJkxH4NOPmayFAM9TPOkQ13Q@mail.gmail.com>
	<87obkt2hdw.fsf@purkki.adurom.net> <87fw643dt8.fsf@purkki.adurom.net>
	<CAFDG9nsx5-pKM2FahgSOZ6D7e+6kWMrZXD9jku+sA1thU5+JDA@mail.gmail.com>
Date: Thu, 27 Sep 2012 16:41:01 +0300
In-Reply-To: <CAFDG9nsx5-pKM2FahgSOZ6D7e+6kWMrZXD9jku+sA1thU5+JDA@mail.gmail.com>
	(Alper Yilmaz's message of "Thu, 27 Sep 2012 12:36:16 +0000")
Message-ID: <87bogr37o2.fsf@purkki.adurom.net> (sfid-20120927_154108_589947_263AFB90)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alper,

please don't mail me privately. I only give public support so that the
whole Linux community can benefit.

Alper Yilmaz <alperyilmaz@gmail.com> writes:

> I tried live USB with Ubuntu 10.04.4 and wireless worked great.

Ok, so this is a regression in Ubuntu. That's good to know.

> Then, I tried to install dhclient, wpasupplicant and network-manager
> of the 10.04 version to my current installation (12.04). I found
> correct deb files and installed them. But after one point, i couldn't
> deal with dependencies.

It's very difficult to install older components to a newer distribution.
Don't do that unless you know what you are doing.

> Which email list is most suitable to ask for help regarding dhclient
> and wpasupplicant?

It depends where the problem is, we still don't know that. Did you try
what I suggested in my previous email? That would help to pinpoint
what's broken.

wpasupplicant mailing list is hostap@lists.shmoo.com, but I have no idea
about dhclient. I recommend filing a bug to Ubuntu as this clearly is a
regression and trying to investigate more where the problem is.

-- 
Kalle Valo
