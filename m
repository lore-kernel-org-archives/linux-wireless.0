Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:46611 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752326AbYLRWfd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:35:33 -0500
Message-ID: <494ACE9B.8010709@warmcat.com> (sfid-20081218_233536_950265_BB5ED842)
Date: Thu, 18 Dec 2008 22:28:43 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Werner Almesberger <werner@openmoko.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill
References: <20081218212234.GI5019@almesberger.net>
In-Reply-To: <20081218212234.GI5019@almesberger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Somebody in the thread at some point said:

> In Openmoko, we're wondering whether we should make the Atheros AR6k

Let me put that simpler for you Werner :-)

"In Openmoko" we already use the nice rfkill interface to turn our USB 
bluetooth device on and off... it certainly stops RF emissions from it.

Now we plan to do the same for our AR6001 implementation... it has no 
switched power to the module, it is "always on".  It seems the only way 
to get it to a low power state is an IOCTL that currently needs to be 
set by a userspace app.

In the same manner as we switch bluetooth, I have asked Werner to write 
a patch that will use rfkill to issue the IOCTL to switch the AR6001 
into low power / no RF mode.

Does that raise any eyebrows?

-Andy
