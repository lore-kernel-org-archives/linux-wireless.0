Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail7.sea5.speakeasy.net ([69.17.117.9]:42299 "EHLO
	mail7.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbXKRXCx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Nov 2007 18:02:53 -0500
Date: Sun, 18 Nov 2007 15:02:38 -0800
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Kalle Valo <Kalle.Valo@nokia.com>, Michael Buesch <mb@bu3sch.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Michael Wu <flamingice@sourmilk.net>, Jiri Benc <jbenc@suse.cz>
Subject: Re: [RFC] b43: multiple MAC addresses support
Message-ID: <20071118230237.GB8672@jm.kir.nu> (sfid-20071118_230301_964695_FBCE358A)
References: <1194572631.4793.64.camel@johannes.berg> <1194605550.4793.93.camel@johannes.berg> <20071111025808.GK4031@jm.kir.nu> <87pryfd8cc.fsf@nokia.com> <1194953217.9116.38.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1194953217.9116.38.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 13, 2007 at 12:26:57PM +0100, Johannes Berg wrote:

> The N800 and similar devices only wake up at DTIM beacons, right? So
> another idea would be to burst beacons but make sure the DTIM beacon
> time doesn't fluctuate away from the DTIM TBTT. This would be possible
> by changing the order of the beacons and adjusting the DTIM count so
> that the beacon with DTIM count zero is always the first.

This could be an improvement for small number of BSSes, but if the DTIM
period starts going up, the delay in sending out multicast/broadcast
frames may not be acceptable anymore depending on application.

-- 
Jouni Malinen                                            PGP id EFC895FA
