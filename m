Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:42615 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363Ab1AKLwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 06:52:13 -0500
Date: Tue, 11 Jan 2011 13:52:07 +0200
From: Jouni Malinen <j@w1.fi>
To: Andy Pyles <andy.pyles@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: packet injection not working on rt2800usb, ath9k
Message-ID: <20110111115207.GA28619@jm.kir.nu>
References: <AANLkTi=2N5A0ZBoULj3d0Bp_GeWQouHGFA_LRWWu1k22@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=2N5A0ZBoULj3d0Bp_GeWQouHGFA_LRWWu1k22@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 06:08:13PM -0500, Andy Pyles wrote:
> I'm using linux-wireless snapshot from December, 2010 with the
> following driver: rt2800usb
> 
> The linux-wireless snapshot for ath9k is from last summer ( July)

> Question: Is this operation supported on these two devices? If not,
> what device can you recommend a device where this does work?

I do not know about rt2800usb, but monitor mode and packet injection
works with ath9k. I'm not sure how packetspammer is doing this, but at
least use of Linux packet socket and simple radiotap header works fine
in my tests. In addition, it could be useful to update your ath9k driver
to make sure you are running with all the latest fixes.

-- 
Jouni Malinen                                            PGP id EFC895FA
