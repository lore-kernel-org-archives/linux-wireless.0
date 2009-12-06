Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:57251 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933911AbZLFRD5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:03:57 -0500
Date: Sun, 6 Dec 2009 18:04:01 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, Tim Blechmann <tim@klingt.org>,
	rjw@sisk.pl, IvDoorn@gmail.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: regression: rt2561 frequent "Arrived at non-free entry" errors in	2.6.32
Message-ID: <20091206170401.GV18989@one.firstfloor.org>
References: <20091204233202.GA13658@basil.fritz.box> <4B1BB44E.90706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B1BB44E.90706@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Both of you have reported this problem on 2.6.32.

For me it seems like the problem went away since I disabled
CONFIG_CFG80211_DEFAULT_PS (that would indicate it's related
to power saving?) 

That is I'm watching it further, but previously the problem
happened every few minutes and now it already works without hickup
for a few hours.

I'll try a positive test (reenabling it) later and also
see if your patch makes a difference. Thanks.

-Andi
