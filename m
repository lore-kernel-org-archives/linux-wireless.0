Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:57180 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYLRWmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 17:42:00 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: AR6k: to rfkill
Date: Thu, 18 Dec 2008 23:37:55 +0100
Cc: Werner Almesberger <werner@openmoko.org>,
	linux-wireless@vger.kernel.org
References: <20081218212234.GI5019@almesberger.net> <494ACE9B.8010709@warmcat.com>
In-Reply-To: <494ACE9B.8010709@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812182337.56050.mb@bu3sch.de> (sfid-20081218_234203_206021_AC9E3893)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 December 2008 23:28:43 Andy Green wrote:
> Somebody in the thread at some point said:
> 
> > In Openmoko, we're wondering whether we should make the Atheros AR6k
> 
> Let me put that simpler for you Werner :-)
> 
> "In Openmoko" we already use the nice rfkill interface to turn our USB 
> bluetooth device on and off... it certainly stops RF emissions from it.
> 
> Now we plan to do the same for our AR6001 implementation... it has no 
> switched power to the module, it is "always on".  It seems the only way 
> to get it to a low power state is an IOCTL that currently needs to be 
> set by a userspace app.
> 
> In the same manner as we switch bluetooth, I have asked Werner to write 
> a patch that will use rfkill to issue the IOCTL to switch the AR6001 
> into low power / no RF mode.
> 
> Does that raise any eyebrows?

Is the wireless kernel driver a binary blob?

-- 
Greetings, Michael.
