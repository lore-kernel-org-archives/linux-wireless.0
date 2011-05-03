Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:48719 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab1ECCcT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 22:32:19 -0400
Received: from mail.atheros.com ([10.234.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 19:31:51 -0700
Date: Mon, 2 May 2011 19:31:58 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [ath9k-devel] [PATCH 1/2] ath9k_htc: Dump base eeprom header for
 UB91/94/95
Message-ID: <20110503023158.GA11667@tux> (sfid-20110503_043235_499794_16B35535)
References: <19897.11321.556139.837633@gargle.gargle.HOWL>
 <201104290116.26355.chunkeey@googlemail.com>
 <19898.4633.920683.992470@gargle.gargle.HOWL>
 <201104291106.21170.chunkeey@googlemail.com>
 <19898.35529.55613.593784@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19898.35529.55613.593784@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 29, 2011 at 02:54:17AM -0700, Sujith wrote:
> Christian Lamparter wrote:
> > Do you really think that everyone will be happy to recompile their stripped & heavily 
> > customised embedded kernels/or compat-wireless just to enable DEBUG and
> > waste precious resources? Even with a PC, this is not necessarily straightforward,
> > especially if the user has never done it before.
> 
> Yeah, this was the reasoning that I used to write a tool to dump eeprom
> data for PCI cards (using libpciaccess), and it is languishing internally. :)
> 
> I agree that there are benefits to having a userspace tool,
> maybe Luis' ath-utils tree can be used. But until then, it would be useful
> to have these in the driver.

Why didn't we ever open your tool up?

  Luis
