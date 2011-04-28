Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41121 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab1D1XQb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 19:16:31 -0400
Received: by bwz15 with SMTP id 15so2710808bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 16:16:30 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Sujith <m.sujith@gmail.com>
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
Date: Fri, 29 Apr 2011 01:16:25 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
In-Reply-To: <19897.11321.556139.837633@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104290116.26355.chunkeey@googlemail.com> (sfid-20110429_011634_708142_5266C743)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 28 April 2011 10:58:33 Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Debugfs file location: <debugfs_mnt>/ieee80211/phy#/ath9k_htc/base_eeprom
> 
If you just want to dump the eeprom, then why not with a userspace utility?
It's pretty easy to write such a thing with libusb, furthermore it's more
versatile and portable so the *BSD-folks are not left out!

Regards,
	Chr
