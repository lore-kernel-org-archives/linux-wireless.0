Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35366 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750875AbYCLK05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 06:26:57 -0400
Date: Wed, 12 Mar 2008 11:26:54 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, kay.sievers@vrfy.org,
	sassmann@suse.de, Geoff Levand <geoffrey.levand@am.sony.com>,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] PS3: gelic: change the prefix of the net interface for
 wireless
In-Reply-To: <20080312162152.0B14.40F06B3A@sm.sony.co.jp>
Message-ID: <Pine.LNX.4.64.0803121125150.15905@vixen.sonytel.be> (sfid-20080312_102706_056172_1C18D432)
References: <20080312162152.0B14.40F06B3A@sm.sony.co.jp>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-506907180-1205317614=:15905"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-506907180-1205317614=:15905
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Wed, 12 Mar 2008, Masakazu Mokuno wrote:
> The gelic driver uses two net interfaces, one for ethernet and the
> other for wireless. They share same MAC address and use 'eth' prefix
> for the name.
> As udev uses the MAC address to check uniqueness, this is
> somewhat problematic.  So change the prefix of the network interface
> name for the wireless so that udev can have an easy way to distinguish
> interfaces.

Now my PS3 has `eth0' and `wlan0_rename'.
I assume we still need changes to udev?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Network and Software Technology Center Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Network and Software Technology Center Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis Bank Zaventem · Swift GEBABEBB08A · IBAN BE39001382358619
---584349381-506907180-1205317614=:15905--
