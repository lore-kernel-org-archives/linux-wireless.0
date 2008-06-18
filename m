Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:49057 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001AbYFRWaI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 18:30:08 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1K95lj-0001Dm-8u
	for linux-wireless@vger.kernel.org; Thu, 19 Jun 2008 00:04:43 +0200
Message-ID: <4859866A.1090300@gmail.com> (sfid-20080619_003017_588260_C6FB3DD2)
Date: Wed, 18 Jun 2008 23:04:26 +0100
MIME-Version: 1.0
To: Bernhard Reiter
	<public-bernhard-fZ64t2NdLluOJsaolrKA/Q@hugh.gmane.org>
CC: =?ISO-8859-1?Q?Stefanik_G=E1bor?=
	<public-netrolller.3d-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org
Subject: Re: 802.11 pccard, Agere 0x0156,0x0003?
References: <200806181715.20516.bernhard@intevation.de> <69e28c910806180831j3625db4h6b93836146349fb@mail.gmail.com>
In-Reply-To: <69e28c910806180831j3625db4h6b93836146349fb@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Stefanik G=E1bor wrote:
> On Wed, Jun 18, 2008 at 5:15 PM, Bernhard Reiter <bernhard@intevation=
=2Ede> wrote:
>> Sitting here a  pc card wireless land adapter.
>> id 0x0156, 0x0003, which probably makes it an Agere card.
>> cardctl info says:
>> "Wireless PC Card Model 0110"

> This appears to be a Wavelan 2 / Orinoco card. Maybe try adding your
> device IDs to the Orinoco driver.

According to <http://dotpups.de/dotpups/Wifi/drivers-for-Puppy-1/lucent=
-agere_README>, this is a Hermes II based card, which is not supported =
by the orinoco driver.

There is a more recent version of the Agere driver available, which has=
 been patched for 2.6 kernels. See <http://ubuntuforums.org/showthread.=
php?t=3D304217>
=20

Regards,

Dave.

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
