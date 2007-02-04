Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.227]:29886 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483AbXBDSYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Feb 2007 13:24:04 -0500
Received: by nz-out-0506.google.com with SMTP id s1so1405654nze
        for <linux-wireless@vger.kernel.org>; Sun, 04 Feb 2007 10:24:03 -0800 (PST)
Message-ID: <9e4733910702041024g2b1e51e0l89cbfb3f0d2e6f70@mail.gmail.com>
Date: Sun, 4 Feb 2007 13:24:03 -0500
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Jouni Malinen" <jkmaline@cc.hut.fi>
Subject: Re: SoftMAC vs FullMAC
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070204180724.GB6632@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <9e4733910702040922n63736d27h7ab027dc90ae8989@mail.gmail.com>
	 <20070204180724.GB6632@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/4/07, Jouni Malinen <jkmaline@cc.hut.fi> wrote:
> I hope you realize that 802.11s is in very early steps (the first draft
> failed to get the needed approval rate in IEEE 802.11 working group) and
> is subject to change.. Whether hardware can run 802.11s (the current
> draft or whatever may end up in the end) is quite open question from my
> view point.. 802.11 requires MAC changes and I'm sure there are hardware
> designs that do not work with the current 802.11s draft no matter what
> the host CPU is doing in the driver/802.11 stack.

What I've read is that there are no changes at the PHY layers for 11s.
If that is the case then any existing hardware should be able to run
11s if the interface allows properly formatted packets to be
transmitted and received. Of course I don't know exactly what is in
the 11s draft since it is secret.

A related issue is merging the Marvell support for the OLPC. Marvell
is doing a FullMAC 11s implementation which requires a coprocessor in
the wireless hardware. Merging a firmware 11s implementation before a
software 11s implementation exists will likely cause problems since
interfaces won't get designed correctly.

I'm concerned that's the vendor's goal is to require a new round of
hardware purchases to support 11s when it doesn't appear to be
necessary. OLPC needs the firmware implementation for power saving
reasons, not to implement the protocol.

-- 
Jon Smirl
jonsmirl@gmail.com
