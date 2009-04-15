Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59278 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbZDOTQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 15:16:54 -0400
Received: by ewy9 with SMTP id 9so52486ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 12:16:52 -0700 (PDT)
Message-ID: <49E632A1.1050605@gmail.com> (sfid-20090415_211658_012050_ED90CB4E)
Date: Wed, 15 Apr 2009 21:16:49 +0200
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: dcbw@redhat.com, linux-wireless <linux-wireless@vger.kernel.org>,
	greg@kroah.com, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:

> The only fixes that drivers are getting in staging now are netdev_ops,
> whitespace cleanups, and trivial fixes.  Nobody is actually rewriting
> the Ralink or Via staging drivers to use mac80211, which is what's
> needed for them to be merged.  Given that they are going nowhere, are

Only rtl8187se and wlan-ng don't have a mac80211 port.

mac80211 drivers:

agnx		-> http://git.sipsolutions.net/agnx.git
at76_usb	-> replacement already in kernel.org code at drivers/net/wireless/at76c50x-usb.[ch]
otus		-> replacement already in kernel.org code at drivers/net/wireless/ar9170/
rt2860		-> rt2800pci.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
rt2870		-> rt2800usb.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
rt3070		-> rt2800usb.[ch] http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git
rtl8187se	-> ???
stlc45xx	-> replacement already in kernel.org code at drivers/net/wireless/p54/p54spi*
winbond		-> http://code.google.com/p/winbondport/
wlan-ng		-> ftp://ftp.linux-wlan.org/pub/linux-wlan-ng/FAQ ???



I hope rt2800pci/usb to be included *ASAP*, because rt2800usb supports
more than 1oo USB devices and rt2800pci is included in a lot of
laptops(ask Torvalds [1] [2])

[1] http://marc.info/?l=linux-netdev&m=121799144422863&w=2
[2] http://marc.info/?l=linux-kernel&m=123187052023831&w=2



regards,
-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
