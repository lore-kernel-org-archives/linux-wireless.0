Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:39402 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbXGAVAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2007 17:00:53 -0400
Date: Sun, 1 Jul 2007 22:32:38 +0200
From: Joerg Mayer <jmayer@loplof.de>
To: Daniel Drake <dsd@gentoo.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, kune@deine-taler.de
Subject: Re: [PATCH] zd1211rw-mac80211: basic regulatory domain support
Message-ID: <20070701203238.GE8218@thot.informatik.uni-kl.de>
References: <20070701163907.39B6B7B409F@zog.reactivated.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070701163907.39B6B7B409F@zog.reactivated.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jul 01, 2007 at 05:39:06PM +0100, Daniel Drake wrote:
> This patch causes zd1211rw-mac80211 to interpret the regdomain in the
> EEPROM and restrict the channels accordingly, like the softmac driver does.

The patch only addresses the allowed channels but not the allowed
maximum power levels. Is this intentional?
I've only looked at the patch, so maybe this is handled elsewhere.


 ciao
       Joerg
--
Joerg Mayer                                           <jmayer@loplof.de>
We are stuck with technology when what we really want is just stuff that
works. Some say that should read Microsoft instead of technology.

