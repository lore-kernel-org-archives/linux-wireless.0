Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52390 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab1D2JG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 05:06:29 -0400
Received: by bwz15 with SMTP id 15so2956247bwz.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 02:06:28 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
Date: Fri, 29 Apr 2011 11:06:20 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
References: <19897.11321.556139.837633@gargle.gargle.HOWL> <201104290116.26355.chunkeey@googlemail.com> <19898.4633.920683.992470@gargle.gargle.HOWL>
In-Reply-To: <19898.4633.920683.992470@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104291106.21170.chunkeey@googlemail.com> (sfid-20110429_110634_166504_3A1C3B0D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 29 April 2011 03:19:21 Sujith wrote:
> Christian Lamparter wrote:
> > On Thursday 28 April 2011 10:58:33 Sujith wrote:
> > > From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> > > 
> > > Debugfs file location: <debugfs_mnt>/ieee80211/phy#/ath9k_htc/base_eeprom
> > > 
> > If you just want to dump the eeprom, then why not with a userspace utility?
> > It's pretty easy to write such a thing with libusb, furthermore it's more
> > versatile and portable so the *BSD-folks are not left out!
> 
> We do have an eeprom dump tool for PCI cards, but hardly any one uses
> that. 
Oh, I used ath_info for ath5k a lot. Especially to get around regdom restrictions.
Sure, your tool won't be able to do that, but never the less.

> It's much more convenient to use debugging features that are present
> in the driver itself. On an embedded board, it makes things a little bit easier.
Do you really think that everyone will be happy to recompile their stripped & heavily 
customised embedded kernels/or compat-wireless just to enable DEBUG and
waste precious resources? Even with a PC, this is not necessarily straightforward,
especially if the user has never done it before.

Regards,
	Chr
