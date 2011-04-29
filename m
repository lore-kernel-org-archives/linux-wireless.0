Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37202 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1D2BQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 21:16:50 -0400
Received: by pwi15 with SMTP id 15so1559966pwi.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 18:16:49 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19898.4633.920683.992470@gargle.gargle.HOWL> (sfid-20110429_031656_420974_0AB1E9D6)
Date: Fri, 29 Apr 2011 06:49:21 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
In-Reply-To: <201104290116.26355.chunkeey@googlemail.com>
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
	<201104290116.26355.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Thursday 28 April 2011 10:58:33 Sujith wrote:
> > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > 
> > Debugfs file location: <debugfs_mnt>/ieee80211/phy#/ath9k_htc/base_eeprom
> > 
> If you just want to dump the eeprom, then why not with a userspace utility?
> It's pretty easy to write such a thing with libusb, furthermore it's more
> versatile and portable so the *BSD-folks are not left out!

We do have an eeprom dump tool for PCI cards, but hardly any one uses
that. It's much more convenient to use debugging features that are present
in the driver itself. On an embedded board, it makes things a little bit easier.

And BSD ? BSD is dead. Adrian is just deluded. :-)

Sujith
