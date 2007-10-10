Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:38590 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJJCVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 22:21:22 -0400
Date: Tue, 9 Oct 2007 19:20:41 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: jt@hpl.hp.com, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org
Subject: Re: wext 64-bit: network manager and wpa_supplicant
Message-ID: <20071010022041.GL14401@jm.kir.nu> (sfid-20071010_032129_375084_37AF2AAA)
References: <1190292526.18521.52.camel@johannes.berg> <20070920165545.GA29452@bougret.hpl.hp.com> <1190307669.18521.94.camel@johannes.berg> <20070920205602.GA15373@bougret.hpl.hp.com> <1190385414.18521.148.camel@johannes.berg> <20070926235135.GA16051@bougret.hpl.hp.com> <1191921316.4013.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1191921316.4013.5.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 09, 2007 at 11:15:16AM +0200, Johannes Berg wrote:

> If I were to venture a guess I'd say that Jouni would accept a (sane)
> replacement if you were to license it under dual BSD/GPL as the rest of
> wpa_supplicant/hostapd.

Maybe, maybe not. License is just one of the reasons (but a strong one;
there's no way I would use GPL-only library here). The other part is in
the likelyhood of target systems having the library available. If it is
not expected to be available in more or less all targets, I do not
really like to start requiring it. wpa_supplicant/hostapd are used in
number of embedded designs and the less external libraries are required
the better.

Unfortunately, I do not have a device that would show the 64-bit issue.
Could you please remind me which devices are affected and how common
they are? So far, not very many people have complained about the issues
with wpa_supplicant on 64-bit systems.

> Could you try wpa_supplicant with kernel patch below on your 32-bit
> machine? I think this should make the problem show up on 32-bit
> machines. Not having a 64-bit machine needn't stop you from fixing the
> alignment problems :) I can then verify that it works and didn't break
> 64/64 setups if you want.

This sounds like an interesting way of resolving the lack of hardware
part of the problem.. ;-)  If this approach is confirmed to work, I
would be quite a bit more likely to actually find time to take a closer
look at the problem.

-- 
Jouni Malinen                                            PGP id EFC895FA
