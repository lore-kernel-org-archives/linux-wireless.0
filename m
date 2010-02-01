Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38652 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755115Ab0BAVXw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 16:23:52 -0500
Subject: Re: ath9k/PCI 168C:002C
From: Pavel Roskin <proski@gnu.org>
To: Bernhard Reiter <ockham@raz.or.at>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1265056347.3610.100.camel@razor>
References: <1265039522.3610.55.camel@razor>
	 <20100201113620.52ahuc39ws8scow4-cebfxv@webmail.spamcop.net>
	 <1265056347.3610.100.camel@razor>
Content-Type: text/plain
Date: Mon, 01 Feb 2010 16:23:43 -0500
Message-Id: <1265059423.15528.21.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-01 at 21:32 +0100, Bernhard Reiter wrote:
> thanks for your hints! unfortunately, as you expected, simply adding the
> PCI id doesn't do the trick. seems like a couple of people tried it
> already:
> http://forum.ubuntuusers.de/topic/atheros-ar5b95-geht-unter-unr-9-10-nicht/
> (in German).

Please try the patch that was posted at
http://bugzilla.kernel.org/show_bug.cgi?id=15180

You can apply it to compat-wireless.

> i haven't tried madwifi yet, though.

I was wrong, it won't work as is.  The ID should be added to HAL as
well.  Unfortunately, I don't know which initialization values are
needed for the chip, and I cannot figure it out from the ath9k patch.

-- 
Regards,
Pavel Roskin
