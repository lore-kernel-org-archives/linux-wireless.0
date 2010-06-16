Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32909 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab0FPOpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jun 2010 10:45:09 -0400
Date: Wed, 16 Jun 2010 10:21:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dennis Borgmann <dennis.borgmann@googlemail.com>
Cc: linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
Subject: Re: "ressource temporarily unavailable" on 2.4 GHz, not on 5GHz
Message-ID: <20100616142158.GC2404@tuxdriver.com>
References: <4C18DA3D.1030303@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C18DA3D.1030303@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 16, 2010 at 04:05:49PM +0200, Dennis Borgmann wrote:
> Hello wireless-list!
> Hello hostapd-list!
> 
> I am using ath5k with hostapd-0.6.9 on a debian running kernel 2.6.34
> and I am observing a "ressource temporarily unavailable" - error code 11
> if I pump out multicast-packets quite fast. I wrote a small
> test-program, that handles this test and as soon as I go down to a
> 8ms-pause or below in betweens the packets, the error is thrown quite
> soon after starting the program. Funny thing is, that this error only
> occurs in g-band (2.4 GHz), not in a-band (5GHz).
> 
> What could be the problem? Is this due to backoff-times in 2.4 GHz, that
> don't occur on 5 GHz? Or could this be a bug?

My only initial thought is that the 2.5GHz band is usually more
utilized.  So there is more likely to be retransmissions, etc.

> Find attached my small piece of code to test and reproduce this effect.

Perhaps you could include actual dmesg output?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
