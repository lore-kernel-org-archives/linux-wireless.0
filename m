Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:60443 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbYLJNsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 08:48:14 -0500
Received: by ey-out-2122.google.com with SMTP id 6so89010eyi.37
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 05:48:12 -0800 (PST)
To: rt2400-devel@lists.sourceforge.net
Subject: Re: [Rt2400-devel] rt2860/wpa dev status
Date: Wed, 10 Dec 2008 14:48:08 +0100
Cc: "Mark Asselstine" <asselsm@gmail.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <919fe2b30810020637n2c9e857ak4ce55bcbf8a50ccb@mail.gmail.com>
In-Reply-To: <919fe2b30810020637n2c9e857ak4ce55bcbf8a50ccb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101448.08990.IvDoorn@gmail.com> (sfid-20081210_144820_473185_23920AE2)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Ralink has provided a new driver for the rt2860 hardware,
I haven't tested it yet but it deserves the attention for one simple reason:
it hooks into mac80211.
It doesn't hook into rt2x00lib yet, and neither does it support everything
mac80211 could do, but it can be used as base for further developing
the rt2800pci drivers by filling the last remaining gaps.

The driver can be found here:
http://kernel.org/pub/linux/kernel/people/ivd/RT28xx_Linux_mac80211_20081203_V2.0-GPL.tgz

Mark, Matthias and Felix you offered/provided help with the rt2800 developers
before. I would really appreciate if you could help me with merging this drivers
into the rt2800pci/rt2800usb drivers. :)
(Other developers are off course welcome as well!)

Ivo

On Thursday 02 October 2008, Mark Asselstine wrote:
> Hello,
> 
> I have some free cycles and would love to help out in getting support
> for rt2860 and wpa support into this project. I can see that such
> support was discussed some at the last development meeting as well as
> in Bug 10754. I have cloned the tree and am ready to go, anyone have
> any pointers to areas I can help out with?
> 
> Regards,
> Mark
> 
> -------------------------------------------------------------------------
> This SF.Net email is sponsored by the Moblin Your Move Developer's challenge
> Build the coolest Linux based applications with Moblin SDK & win great prizes
> Grand prize is a trip for two to an Open Source event anywhere in the world
> http://moblin-contest.org/redirect.php?banner_id=100&url=/
> _______________________________________________
> Rt2400-devel mailing list
> Rt2400-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/rt2400-devel
> 


