Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:49378 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752712AbZHEWgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 18:36:13 -0400
Message-ID: <4A7A0952.5020307@redfish-solutions.com>
Date: Wed, 05 Aug 2009 15:36:02 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Best (ath9k) miniPCI card for testing overall AP functionality
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to get Astlinux ready for the 0.7 release, but we've been
hamstrung in testing because of issues with the ath5k drivers on our
test platform...  so I've been considering getting different hardware
for testing.  We've not been able to shake-down our transition from
wireless-tools to iw, or from hostapd 0.6.8 to 0.6.9.

I'm guessing that the ath9k tends to be further along in functionality,
and more stable, than the ath5k?

If that's the case, one of our partners that gives discounted pricing on
F/OSS development hardware has the following NICs:

Ubiquiti SR71-A  = Atheros AR9160 with DFS SUPPORT
Ubiquiti SR71-12 = Atheros AR9220 with DFS SUPPORT
Ubiquiti SR71-15 = Atheros AR9220 with DFS SUPPORT



I'm looking for b/g or n hardware, and the more power, the better.

The 'A' doesn't seem to work with x86 based systems, as far as I can tell.

The '12' is b/g/n, 27dBm and uses MMCX connectors, and is type III-A format.

The '15' is a/n only, also 27dBm and uses MMCX connectors... also type
III-A format.

I'm leaning towards a '12', but they're not cheap.

According to:

http://linuxwireless.org/en/users/Drivers/ath9k

and:

http://linuxwireless.org/en/users/Drivers/ath9k/products/external

none of the above cards are supported...  but that assumes that the Wiki
is up to date.  Also the AR9220 isn't shown on the list of supported
chipsets.

Can anyone confirm or deny that it's unsupported?

Thanks,

-Philip

