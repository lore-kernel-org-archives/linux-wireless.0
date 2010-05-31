Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server.heaven-czfree.net ([78.108.102.201]:54077 "EHLO
	smtp.heaven-czfree.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757053Ab0EaUOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 16:14:51 -0400
From: "Jaroslav Fojtik" <jafojtik@seznam.cz>
To: Peter Chubb <peter.chubb@nicta.com.au>,
	linux-wireless@vger.kernel.org
Date: Mon, 31 May 2010 22:05:13 +0200
MIME-Version: 1.0
Subject: Re: Commit 6b5d,.. breaks ath5k in WPA-enabled networks
Message-ID: <4C041679.23801.36589@jafojtik.seznam.cz>
In-reply-to: <w47hmkh1b4.wl%peter@chubb.wattle.id.au>
References: <w47hmkh1b4.wl%peter@chubb.wattle.id.au>
Content-type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> With Linus's current head-of-tree my ath5k cannot associate with
> WPA-enabled access points.  I bisected back to this patch:

I hope that not only WPA association is corrupted. I have already 
reported association failures for plain connections.

> 	    Since commit 6b5d117eddc09cd976ad8030d715f4350f598a22 
> 	    ath5k: clean up queue manipulation
I have tested to revert this patch, but I did not observe any effect.

There must be something wrong somewhere else.

regards
   Jara


> I suspect at least one of the two wake-up calls that were removed is
> actually necessary.
> 
> Reverting the patch restores correct behaviour.
> --
> Dr Peter Chubb                                  peter DOT chubb AT nicta.com.au
> http://www.ertos.nicta.com.au               ERTOS within National ICT Australia
> All things shall perish from under the sky/Music alone shall live, never to die
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


