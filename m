Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:42870 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZLHJ5t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 04:57:49 -0500
Date: Tue, 8 Dec 2009 10:57:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
	Tim Blechmann <tim@klingt.org>, rjw@sisk.pl, IvDoorn@gmail.com,
	linville@tuxdriver.com
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in	2.6.32
Message-ID: <20091208095755.GT18989@one.firstfloor.org>
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com> <200912080006.28892.s.L-H@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200912080006.28892.s.L-H@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch doesn't seem to change this particular issue, disabling 
> powersaving however makes rt62pci work again.

Yes confirmed here. Haven't seen it in a day or so with disabled power
saving.

However I haven't tried the patch with power saving enabled.

-andi

-- 
ak@linux.intel.com -- Speaking for myself only.
