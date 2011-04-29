Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42684 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421Ab1D2Jvq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Apr 2011 05:51:46 -0400
Received: by pvg12 with SMTP id 12so2221146pvg.19
        for <linux-wireless@vger.kernel.org>; Fri, 29 Apr 2011 02:51:46 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19898.35529.55613.593784@gargle.gargle.HOWL> (sfid-20110429_115149_490844_59AED538)
Date: Fri, 29 Apr 2011 15:24:17 +0530
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, Luis.Rodriguez@atheros.com
Subject: Re: [PATCH 1/2] ath9k_htc: Dump base eeprom header for UB91/94/95
In-Reply-To: <201104291106.21170.chunkeey@googlemail.com>
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
	<201104290116.26355.chunkeey@googlemail.com>
	<19898.4633.920683.992470@gargle.gargle.HOWL>
	<201104291106.21170.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> Do you really think that everyone will be happy to recompile their stripped & heavily 
> customised embedded kernels/or compat-wireless just to enable DEBUG and
> waste precious resources? Even with a PC, this is not necessarily straightforward,
> especially if the user has never done it before.

Yeah, this was the reasoning that I used to write a tool to dump eeprom
data for PCI cards (using libpciaccess), and it is languishing internally. :)

I agree that there are benefits to having a userspace tool,
maybe Luis' ath-utils tree can be used. But until then, it would be useful
to have these in the driver.

Sujith
