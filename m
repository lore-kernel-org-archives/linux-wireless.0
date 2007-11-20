Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960AbXKTREu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 12:04:50 -0500
Subject: Re: Linux Drivers needed for 802.11
From: Dan Williams <dcbw@redhat.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: devel@driverdev.osuosl.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890711192124j418667b1w94e11737a7f1aea3@mail.gmail.com>
References: <43e72e890711192124j418667b1w94e11737a7f1aea3@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 20 Nov 2007 12:01:25 -0500
Message-Id: <1195578085.3389.47.camel@localhost.localdomain> (sfid-20071120_170453_949687_CE9F43F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-11-20 at 00:24 -0500, Luis R. Rodriguez wrote:
> Greg,
> 
> http://linuxdriverproject.org/twiki/bin/view/Main/DriversNeeded#802_11_Wireless_Network_cards
> 
> This has a list of "needed" 802.11 drivers. It needs some updating as
> we have quite a few new drivers and some are already in the works. I
> was about to update this list to reflect our current driver list and
> also add all 802.11n info I have but considered fist moving it to
> linuxwireless.org so we can arrange this a bit better. Reason for
> doing so is to let us arrange it as we can keep better track of it. I
> still think we should use LinuxDriverProject to inform developers of
> new driver efforts needed and to try to help spawn such projects and
> keep track of them. Any comments on this suggested arrangement?

InProComm 2120 chipset is unsupported, but I doubt many people will care
because it's a b-only chipset.  However, I believe that InproComm got
bought in 2004 by MediaTek, which makes a lot of embedded 802.11 parts
for which there are no wireless drivers at all.  I've got two IPN 2120
MiniPCI cards if somebody wants to take a stab at one.

There is also no support for the AboCom Systems, Inc. SDIO Wifi cards
like the SDW11G:

http://www.geeks.com/details.asp?invtid=SDW11G&cpc=SCH

There is a mac80211 driver for 88w8335 that's a port of the mrv8k driver
here:

http://david.woodhou.se/mrv.tar.gz

There's also a whole host of SIS chips, the 160u, 162u, and 163u.  These
are found in (for example) the TRENDnet TEW-424UB v2.  SIS released
linux drivers for the 160 and 162, but they are atheros/nvidia-style
binary blob modules.

Dan


