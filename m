Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:36540 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499AbXBDSr0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 13:47:26 -0500
Date: Sun, 4 Feb 2007 10:47:24 -0800
From: Jouni Malinen <jkmaline@cc.hut.fi>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: SoftMAC vs FullMAC
Message-ID: <20070204184724.GD6632@jm.kir.nu>
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com> <20070204180724.GB6632@jm.kir.nu> <9e4733910702041024g2b1e51e0l89cbfb3f0d2e6f70@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9e4733910702041024g2b1e51e0l89cbfb3f0d2e6f70@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 04, 2007 at 01:24:03PM -0500, Jon Smirl wrote:

> What I've read is that there are no changes at the PHY layers for 11s.
> If that is the case then any existing hardware should be able to run
> 11s if the interface allows properly formatted packets to be
> transmitted and received. Of course I don't know exactly what is in
> the 11s draft since it is secret.

Hardware may be able to take care of most needed functionality, but
whether firmware is going to allow this is completely different
question.. Amongst other things, IEEE 802.11s/D1.0 is adding new fields
to the frame headers and that is likely to get into problems with number
of firmware implementations.

> A related issue is merging the Marvell support for the OLPC. Marvell
> is doing a FullMAC 11s implementation which requires a coprocessor in
> the wireless hardware. Merging a firmware 11s implementation before a
> software 11s implementation exists will likely cause problems since
> interfaces won't get designed correctly.

I would not call that 11s. It may be a snapshot of a proposal for
802.11s, but IEEE 802.11s is far from being complete, so better call
this Marvell implementation something else.

> I'm concerned that's the vendor's goal is to require a new round of
> hardware purchases to support 11s when it doesn't appear to be
> necessary. OLPC needs the firmware implementation for power saving
> reasons, not to implement the protocol.

Vendors are usually more interested in selling new hardware than adding
support for new functionality in old firmware (no money coming in)..
 
-- 
Jouni Malinen                                            PGP id EFC895FA
