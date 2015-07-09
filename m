Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ns.iliad.fr ([212.27.33.1]:33201 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbbGIPcx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 11:32:53 -0400
Message-ID: <1436455659.36587.131.camel@sakura.staff.proxad.net> (sfid-20150709_173256_566115_178A00FD)
Subject: Re: [PATCH v5] Add new mac80211 driver mwlwifi.
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: David Lin <dlin@marvell.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Thu, 09 Jul 2015 17:27:39 +0200
In-Reply-To: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
References: <92d77d0990b94d23ae66fb69fb55a6fb@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Fri, 2015-07-03 at 06:10 +0000, David Lin wrote:

Hello,

> The Linux driver for WRT1900AC. The work was initially developed as
> part of openwrt effort and maintained on
> https://github.com/kaloz/mwlwifi.

I see *massive* code duplication with the mwl8k driver.

This is, I guess, not a surprise since the supported chipset are an
evolution of the ones supported by mwl8k, just look at how close/similar
the descriptor format is.

The problem is that each new Marvell chipset comes with a new firmware
version, and there is no effort to have a common firmware API or code
base that supports multiple chipsets.

That pushes the bloat on the kernel side, do we really agree on that ?

-- 
Maxime


