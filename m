Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29074 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbZHFKqY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 06:46:24 -0400
Subject: Re: Best (ath9k) miniPCI card for testing overall AP functionality
From: Pavel Roskin <proski@gnu.org>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A7A0952.5020307@redfish-solutions.com>
References: <4A7A0952.5020307@redfish-solutions.com>
Content-Type: text/plain
Date: Thu, 06 Aug 2009 06:46:18 -0400
Message-Id: <1249555578.24439.38.camel@ct>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-08-05 at 15:36 -0700, Philip A. Prindeville wrote:
> I'm trying to get Astlinux ready for the 0.7 release, but we've been
> hamstrung in testing because of issues with the ath5k drivers on our
> test platform...  so I've been considering getting different hardware
> for testing.  We've not been able to shake-down our transition from
> wireless-tools to iw, or from hostapd 0.6.8 to 0.6.9.
> 
> I'm guessing that the ath9k tends to be further along in functionality,
> and more stable, than the ath5k?

I think it's true for AP functionality.  In any case, there is not much
code shared between ath5k and ath9k, so if you have a driver specific
problem with ath5k, ath9k is unlikely to have the same problem.

> If that's the case, one of our partners that gives discounted pricing on
> F/OSS development hardware has the following NICs:
> 
> Ubiquiti SR71-A  = Atheros AR9160 with DFS SUPPORT
> Ubiquiti SR71-12 = Atheros AR9220 with DFS SUPPORT
> Ubiquiti SR71-15 = Atheros AR9220 with DFS SUPPORT
> 
> 
> 
> I'm looking for b/g or n hardware, and the more power, the better.
> 
> The 'A' doesn't seem to work with x86 based systems, as far as I can tell.

I have an AR9160 based miniPCI card, and it's working fine on a x86_64
based system.  I don't think I tested it with a 32-bit kernel, but I
don't expect any problems.

I think the Ubiquiti page for the card would have a warning it it was
true, but I don't see any warning here:
http://www.ubnt.com/products/sr71a.php

By the way, AR9160 is supported by MadWifi, unlike AR9280.  MadWifi is
not actively developed, but if you need another reference point, you'll
have it.

> The '12' is b/g/n, 27dBm and uses MMCX connectors, and is type III-A format.
> 
> The '15' is a/n only, also 27dBm and uses MMCX connectors... also type
> III-A format.
> 
> I'm leaning towards a '12', but they're not cheap.
> 
> According to:
> 
> http://linuxwireless.org/en/users/Drivers/ath9k
> 
> and:
> 
> http://linuxwireless.org/en/users/Drivers/ath9k/products/external
> 
> none of the above cards are supported...  but that assumes that the Wiki
> is up to date.

I don't thing the term "up to date" really could apply here.  It would
apply it there was a definite list and it was easy to update the wiki
from it.

In fact, the list is only updated when somebody has such device and
makes sure that it works.  As you said, Ubiquiti card are not cheap.

>   Also the AR9220 isn't shown on the list of supported
> chipsets.

The Atheros people here should know better, but I think either AR9220
implies AR9280 or vice versa.

MikroTik RouterBoard R52N has a chip marked AR9220, yet we know that
it's supported.

> Can anyone confirm or deny that it's unsupported?

I'm quite sure that all those cards are supported, but I cannot
guarantee anything.

-- 
Regards,
Pavel Roskin
